#Request certificate from AWS

resource "aws_acm_certificate" "acm_certificate" {
    domain_name = var.domain_name
    subject_alternative_names = [var.alternative_name]
    validation_method = "DNS"

lifecycle {
  
  create_before_destroy = true
}

}

#Get Details about Route53 zone

data "aws_route53_zone" "route53_zone" {

    name = var.domain_name
    private_zone = false

}


