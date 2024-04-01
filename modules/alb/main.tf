resource "aws_lb" "frontend" {
    name =  "${var.project1_name}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.test_security_group_id]
    subnets = [var.public_subnet_az1_id , var.public_subnet_az2_id]
    enable_deletion_protection = false
  
  tags = {

    Name = "${var.project1_name}-alb"
  }
}

resource "aws_lb_target_group" "alb_target_group1" {
  
  name = "${var.project1_name}-tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

    health_check {
      
      enabled = true
      interval = 300
      path = "/"
      timeout = 60 
      matcher = 200
      healthy_threshold = 5 
      unhealthy_threshold = 5 

    }

    lifecycle {
      
      create_before_destroy = false
    }
}

resource "aws_lb_listener" "alb_http_listener1" {
    
    load_balancer_arn = aws_lb.frontend.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "redirect"
    
    redirect {
      port = 443
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
    
    }
}

resource "aws_lb_listener" "alb_https_listener1" {

    load_balancer_arn = aws_lb.frontend.arn
    port = 443
    protocol = "HTTP"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = var.certificate_arn #get value from arn module(output.tf)
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_target_group1.arn
    }
  
}

resource "aws_lb" "backend" {

    name = "${var.project2_name}-alb"
    internal = false
    load_balancer_type = "application" 
    security_groups = [var.test_security_group_id]
    subnets = [var.public_subnet_az1_id, var.public_subnet_az2_id]
    enable_deletion_protection = false

    tags = {
      Name = "${var.project2_name}-alb" 
    }
}

resource "aws_lb_target_group" "alb_target_group2" {

    name = "${var.project2_name}-tg"
    target_type = "instance"
    protocol = "HTTP"
    port = 80
    vpc_id = var.vpc_id

    health_check {
        
        enabled = true
        interval = 300
        path = "/"
        timeout = 60
        matcher = 200
        unhealthy_threshold = 5
        healthy_threshold = 5
    }
        lifecycle {

            create_before_destroy = false
        }
    
}

resource "aws_lb_listener" "alb_http_listener2" {

    load_balancer_arn = aws_lb.backend.arn 
    port = 80
    protocol = "HTTP" 

    default_action {
      
      type = "redirect"
      redirect {
        
        port = 443
        protocol = "HTTPS" 
        status_code = "HTTP_301"

      }
    }


}

resource "aws_lb_listener" "alb_https_listener2" {

    load_balancer_arn = aws_lb.backend.arn
    port = 443
    protocol = "HTTP"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = var.certificate_arn #get value from arn module(output.tf)
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.alb_target_group2.arn
    } 
}