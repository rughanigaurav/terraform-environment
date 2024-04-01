provider "aws" {

    region  = var.region
    profile = "default"  
}


module "vpc" {

    source                      =   "../modules/vpc"
    #environment                 =   var.environment
    region                      =   var.region
    project_name                =   var.project_name
    vpc_cidr                    =   var.vpc_cidr
    public_subnet_az1_cidr      =   var.public_subnet_az1_cidr
    public_subnet_az2_cidr      =   var.public_subnet_az2_cidr
    private_subnet_az1_cidr     =   var.private_subnet_az1_cidr
    private_subnet_az2_cidr     =   var.private_subnet_az2_cidr
  
}

module "acm" {

    source                      = "../modules/acm"
    domain_name                 = var.domain_name
    alternative_name            = var.alternative_name
  
}

module "nat-gateway" {

    source = "../modules/nat-gateway"
    public_subnet_az1_id    = var.public_subnet_az1_id
    public_subnet_az2_id    = var.public_subnet_az2_cidr
    internet_gateway        = var.internet_gateway
    vpc_id                  = var.vpc_id
    private_subnet_az1_id   = var.private_subnet_az1_id
    private_subnet_az2_id   = var.private_subnet_az2_id

}