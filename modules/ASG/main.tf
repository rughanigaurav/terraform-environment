resource "aws_autoscaling_group" "test" {

    name = "${var.project1_name}-asg"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    health_check_grace_period = 300
    vpc_zone_identifier = var.lb_subnet
    target_group_arns = [aws_lb_target_group.alb_target_group1]

    enabled_metrics = [
    
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstance",
    "GroupTotalInstance"
    
    ]

}
resource "aws_autoscaling_group" "test" {

    name = "${var.project2_name}-asg"
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    health_check_grace_period = 300
    vpc_zone_identifier = var.lb_subnet
    target_group_arns = [aws_lb_target_group.alb_target_group1]

    enabled_metrics = [
    
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstance",
    "GroupTotalInstance"
    
    ]

  
}