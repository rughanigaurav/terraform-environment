variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_subnet_az1_cidr" {}
variable "private_subnet_az2_cidr" {}
#variable "environment" {}
variable "domain_name" {}
variable "alternative_name" {}
variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "internet_gateway" {}
variable "ROUTE" {
  type = list(object({ cidr_block=string, gateway_id=string }))
}
variable "ami" {}
variable "instance_type" {}
variable "vpc_id" {}
variable "private_subnet_az1_id" {}
variable "private_subnet_az2_id" {}
variable "project1_name" {}
variable "project2_name" {}
variable "certificate_arn" {}
variable "test_security_group_id" {}