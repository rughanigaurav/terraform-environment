# Required Variable for acm module

variable "domain_name" {

  type = string
  default = "xyz.com"
  
}

variable "alternative_name" {

  type = string
  default = "*.xyz.com"
  
}

#Request certificate from AWS for testing
 resource "aws_acm_certificate" "acm_certificate" {

    domain_name = var.domain_name 
    subject_alternative_names = [var.alternative_name] 
    validation_method = "DNS" 
 lifecycle {


  create_before_destroy = true 

} 

} 

#Route52 zone

data "aws_route53_zone" "route53_zone" { 

    name = var.domain_name 
    private_zone = false 

}