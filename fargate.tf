# Partially copied from  https://github.com/Oxalide/terraform-fargate-example/blob/master/main.tf
data "aws_subnet" "selected" {
  id = module.private1c.subnet_id
}
data "aws_caller_identity" "current" {}

# ALB Security group
# This is the group you need to edit if you want to restrict access to your application
resource "aws_security_group" "lb" {
  name        = "${var.environment}-alb"
  description = "controls access to the ALB"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.environment}-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### ALB

resource "aws_lb" "main" {
  name            = "${var.environment}-alb"
  subnets         = [module.public1c.subnet_id,module.public1b.subnet_id,module.public1a.subnet_id]
  security_groups = ["${aws_security_group.lb.id}"]
}

resource "aws_alb_target_group" "app" {
  name        = "${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_subnet.selected.vpc_id
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}

### ECS

resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-cluster"
}

locals {
  fargate_cpu = 256
  fargate_memory = 512
  log_group_name = "/ecs/${var.environment}-task_definition"
}
resource "aws_cloudwatch_log_group" "taskdefinition" {
  name = local.log_group_name
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.environment}-secure-nginx-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.fargate_cpu
  memory                   = local.fargate_memory
  task_role_arn            = aws_iam_role.task_definition.arn
  execution_role_arn       = aws_iam_role.task_definition.arn
  container_definitions = <<DEFINITION
[
  {
    "cpu": ${local.fargate_cpu},
    "image": "${var.image_uri_with_tag}",
    "memory": ${local.fargate_memory},
    "name": "app",
    "networkMode": "awsvpc",
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": null,
      "options": {
        "awslogs-group": "${local.log_group_name}",
        "awslogs-region": "${data.aws_region.current.name}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "portMappings": [
      {
        "containerPort": ${var.app_port},
        "protocol": "tcp",
        "hostPort": ${var.app_port}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name            = "${var.environment}-nginx-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = [module.private1a.subnet_id,module.private1b.subnet_id,module.private1c.subnet_id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "app"
    container_port   = var.app_port
  }

  depends_on = [
    aws_lb_listener.front_end,
  ]
}


resource "aws_iam_role" "task_definition" {
  name = "${var.environment}-task_definition"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "task_definition" {
  name = "${var.environment}-task_definition"
  role = aws_iam_role.task_definition.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
POLICY
}
