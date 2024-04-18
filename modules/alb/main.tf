# terraform aws create security group
resource "aws_security_group" "test_security_group" {
  name        = "test"
  description = "Apply security to access servers"
  vpc_id      = var.vpc_id
  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Reverse_Proxy"
    from_port        = 3304
    to_port          = 3304
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "OAuth"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }  
  ingress {
    description      = "Allow-SSH-From-Internal-Server"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/22"]
  }
  ingress {
    description      = "Allow-ICMP-From-Trothlabs"
    from_port        = 1
    to_port          = 1
    protocol         = "tcp"
    cidr_blocks      = ["103.105.233.106/32"]
  }
  
  ingress {
    description      = "Allow-SSH-From-Trothlabs"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["103.105.233.106/32"]
  }
  ingress {

    description     = "Allow-Postgres-From-Prolix"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["103.105.233.106/32"] 

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags   = {
    Name = "prolix-SG"
  }
}

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

resource "aws_launch_configuration" "frontend" {
    name = "frontend-configuration"
    image_id = var.frontendimage_id
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = [aws_security_group.test_security_group]
    provisioner "remote-exec" {

      inline = [

            "sudo apt update",
            "sudo apt upgrade -y",
            "sudo apt install supervisor -y",
            "sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https",
            "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg",
            "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list",
            "sudo apt update",
            "sudo apt install caddy -y",
            "sudo systemctl enable caddy",
            "sudo systemctl start caddy",
            "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&",
            "sudo apt update",
            "sudo apt install nodejs -y"

      ]
    }
    lifecycle {

      create_before_destroy = true
    }

    root_block_device {

      volume_size = 30
    }

}

resource "aws_launch_configuration" "backend" {

    name = "backend-configuration"
    instance_type = var.instance_type
    image_id = var.backendimage_id
    key_name = var.key_name
    security_groups = aws_security_group.test_security_group
    provisioner "remote-exec" {

        inline = [

        "sudo apt update",
        "sudo apt upgade -y",
        "sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https",
        "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg",
        "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list",
        "sudo apt update",
        "sudo apt install caddy -y",
        "sudo systemctl enable caddy",
        "sudo systemctl start caddy",
        "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&",
        "sudo apt update",
        "sudo apt install nodejs -y",
        "sudo apt install supervisor -y"
        ]
    }

    root_block_device {

      volume_size = 30
    }
}


#ASG for ec2 instance
resource "aws_autoscaling_group" "test" {

    name = "${var.project1_name}-asg"
    launch_configuration = "$(aws_launch_configuration.frontend)"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    health_check_grace_period = 300
    health_check_type = "EC2"
    force_delete = true
    vpc_zone_identifier = var.lb_subnet
    target_group_arns = aws_lb_target_group.alb_target_group1

    enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstance",
    "GroupTotalInstance"
    ]
tag {

      key = "Name"
      value = "Backend-ASG"
      propagate_at_launch = true
    }
}
resource "aws_autoscaling_group" "test2" {

    name = "${var.project2_name}-asg"
    launch_configuration = "$(aws_launch_configuration.backend.name)"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    health_check_type = "EC2"
    health_check_grace_period = 300
    force_delete = true
    vpc_zone_identifier = var.lb_subnet
    target_group_arns = [aws_lb_target_group.alb_target_group1]

    enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstance",
    "GroupTotalInstance"
    ]
tag {

      key = "Name"
      value = "Backend-ASG"
      propagate_at_launch = true
    }
}