provider "aws" {
    region  = var.region
    profile = "default"
}

module "vpc" {
    source                      =   "../modules/vpc"
    region                      =   var.region
    project_name                =   var.project_name
    vpc_cidr                    =   var.vpc_cidr
    public_subnet_az1_cidr      =   var.public_subnet_az1_cidr
    public_subnet_az2_cidr      =   var.public_subnet_az2_cidr
    private_subnet_az1_cidr     =   var.private_subnet_az1_cidr
    private_subnet_az2_cidr     =   var.private_subnet_az2_cidr
}

module "nat-gateway" {
    source = "../modules/nat-gateway"
    public_subnet_az1_id        = module.vpc.public_subnet_az1_id
    public_subnet_az2_id        = module.vpc.public_subnet_az1_id
    internet_gateway            = var.internet_gateway
    vpc_id                      = module.vpc.vpc_id
    private_subnet_az1_id       = var.private_subnet_az1_id
    private_subnet_az2_id       = var.private_subnet_az2_id
}

module "security-group" {
    source                      = "../modules/security-group"
    vpc_id                      = module.vpc.vpc_id
    security_group              = var.security_group
}

module "acm" {
    source                      = "../modules/acm"
    domain_name                 = var.domain_name
    alternative_name            = var.alternative_name 
}

module "alb" {
    source = "../modules/alb"
    project1_name               = var.project1_name
    project2_name               = var.project2_name
    public_subnet_az1_id        = module.vpc.public_subnet_az1_id
    public_subnet_az2_id        = module.vpc.public_subnet_az2_id
    vpc_id                      = module.vpc.vpc_id
    certificate_arn             = module.acm.certificate_arn
    test_security_group_id      = module.security-group.test_security_group_id
}

module "ec2" {
    source = "../modules/ec2"
    instance_type               = var.instance_type
    ami                         = var.ami
    public_subnet_az1_id        = var.public_subnet_az1_id 
    private_subnet_az1_id       = var.private_subnet_az1_id
    test_security_group_id      = var.test_security_group_id
    security_group              = var.security_group
}

module "rds" {
    source = "../modules/rds"
    vpc_id = var.vpc_id
    
    ami = var.ami
    private_subnet_az1_cidr = var.private_subnet_az1_cidr
    private_subnet_az2_cidr = var.private_subnet_az2_cidr
    public_subnet_az1_cidr = var.public_subnet_az1_cidr
    public_subnet_az2_cidr = var.private_subnet_az2_cidr
}

module "s3-bucket" {

    source = "../modules/s3-bucket"
  
}

module "ASG" {

    source = "../modules/ASG"
    max_size = var.max_size
    min_size = var.min_size
    project1_name = var.project1_name
    project2_name = var.project2_name
    desired_capacity = var.desired_capacity
    lb_subnet = var.lb_subnet
    key_name = var.key_name
    instance_type = var.instance_type
    image_id = var.image_id
  
}

module "cognito" {

    source = "../modules/cognito"
    region = var.region
    userpool_name = var.userpool_name
    client_name = var.client_name

}

module "IAM" {

    source = "../modules/IAM"
  
}