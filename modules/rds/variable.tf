variable "vpc_cidr_block" {

    default     = "10.0.0.0/16"
    description = "Private-VPC"
    type        = string
  
}
variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
  default     = "t2.micro"
}
variable "public_subnet_az1_cidr" {

    default     = "10.0.0.0/24"
    description = "Public subnet az1 CIDR-Block"
    type        = string
  
}
variable "public_subnet_az2_cidr" {

    default     = "10.0.3.0/24"
    description = "Public subnet az2 CIDR-Block"
    type        = string
  
}
variable "private_subnet_az1_cidr" {

    default     = "10.0.2.0/24"
    description = "Private subnet az1 CIDR-Block"
    type        = string
  
}
variable "private_subnet_az2_cidr" {

    default     = "10.0.1.0/24"
    description = "Private subnet az2 CIDR-Block"
    type        = string
  
}   
variable "database-instance-class" {

    default = "db.t3.micro"
    description = "Database instance class"
  
}
variable "database-instance-identifier" {

    default = "test-staging"
    description = "Database instance class"
  
}
variable "domain-name" {
    default = "xyz.com"
    description = "domain-name"
    type = string
  
}
variable "record-name" {
    default = "www"
    description = "staging.linxap.com"
    type = string
  
}
variable "ami" {
  description = "ami id"
  type        = string
  default     = "ami-006dcf34c09e50022"
}

variable "aws_felb_service_account" {
    description = "F-ALB_ARN"
    type = string
    default = ""
}