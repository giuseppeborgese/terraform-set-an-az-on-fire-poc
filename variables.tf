variable "vpc_name" {
  description = ""
}

variable "vpc_cidr_block" {
  description = ""
}

variable "cidr_pub_1a" {
  description = "the public subnet cidr for availability_zone A"
}
variable "cidr_pub_1b" {
  description = "the public subnet cidr for availability_zone B"
}

variable "cidr_pub_1c" {
  description = "the public subnet cidr for availability_zone C"
}

variable "cidr_priv_1a" {
  description = "the private subnet cidr for availability_zone A"
}

variable "cidr_priv_1b" {
  description = "the private subnet cidr for availability_zone B"
}

variable "cidr_priv_1c" {
  description = "the private subnet cidr for availability_zone C"
}

variable "environment" {
  description = ""
}
####### fargete variable #####

variable "app_port" {
  default = 80
  description = "for my test is ok use the default port 80"
}

variable "image_uri_with_tag" {
  default = "public.ecr.aws/nginx/nginx:latest"
  description = "from ecr pubblic container gallery https://gallery.ecr.aws"
}
