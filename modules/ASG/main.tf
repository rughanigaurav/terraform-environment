resource "aws_launch_configuration" "frontend" {
    name = "frontend-configuration"
    image_id = var.image_id
    instance_type = var.instance_type
    key_name = var.key_name
    security_groups = aws_security_group.test_security_group_id
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
      volume_type = gp2
    }

}


resource "aws_launch_configuration" "backend" {

    name = "backend-configuration"
    instance_type = var.instance_type
    image_id = var.image_id
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
      volume_type = gp2
    }

}


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