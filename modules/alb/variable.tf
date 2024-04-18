variable "project1_name" {}
variable "project2_name" {}
variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "vpc_id" {}
variable "certificate_arn" {}
variable "test_security_group_id" {}
#Required Variable for ASG group
variable "max_size" {}
variable "min_size" {}
variable "desired_capacity" {}
variable "lb_subnet" {}
variable "key_name" {}
variable "instance_type" {}
variable "frontendimage_id" {}
variable "backendimage_id" {}
variable "security_group" {}