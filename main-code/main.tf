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