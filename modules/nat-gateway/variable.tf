variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}
variable "internet_gateway" {}
variable "vpc_id" {}
variable "private_subnet_az1_id" {}
variable "private_subnet_az2_id" {}
variable "ROUTE" {
  type = list(object({ cidr_block=string, gateway_id=string }))
}
