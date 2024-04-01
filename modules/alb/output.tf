output "aws_lb_target_group1_arn" {
    value = aws_lb_target_group.alb_target_group1.arn
}

output "frontend_load_balancer_dns_name" {
    value = aws_lb.frontend.dns_name
}

output "frontend_load_balancer_zone_id" {
    value = aws_lb.frontend.zone_id
}

output "aws_lb_target_group2_arn" {
    value = aws_lb_target_group.alb_target_group2.arn
}

output "backend_load_balancer_dns_name" {
  value = aws_lb.backend.dns_name
}

output "backend_load_balancer_zone_id" {
    value = aws_lb.backend.zone_id 
}