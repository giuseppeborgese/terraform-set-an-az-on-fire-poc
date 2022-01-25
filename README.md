# Terraform Set an AZ on fire POC

I don't want to really set on fire an AWS datacenter, but I would like to perform a test to know if my application is resilient to a huge disaster event like a down of a single Availability Zone (from now on called AZ) in AWS.


Complete article with all instructions and explanations in this [linkedin article](https://www.linkedin.com/pulse/set-fire-aws-availability-zone-giuseppe-borgese)

at this link

![schema](https://raw.githubusercontent.com/giuseppeborgese/terraform-set-an-az-on-fire-poc/master/diagram.png)



# Usage Example
``` hcl
module "poc" {
  source = "github.com/giuseppeborgese/terraform-set-an-az-on-fire-poc"
  vpc_name = "poc"
  vpc_cidr_block = "10.10.0.0/16"
  cidr_pub_1a = "10.10.0.0/24"
  cidr_pub_1b = "10.10.1.0/24"
  cidr_pub_1c = "10.10.2.0/24"
  cidr_priv_1a = "10.10.3.0/24"
  cidr_priv_1b = "10.10.4.0/24"
  cidr_priv_1c = "10.10.5.0/24"
  environment = "test"
}
```
