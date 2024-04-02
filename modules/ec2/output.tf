output "jump_server_public_ip" {

    value = aws_instance.jump-server[*].public_ip

}

output "Frontend_private_ip" {
  
  value = aws_instance.Frontend-S1[*].Frontend_private_ip
}

output "jump_instance_id" {

    value = aws_instance.jump-server.id

}

output "Frontend_instance_id" {

    value = aws_instance.Frontend-S1.id

}

output "Backend_instance_id" {

    value = aws_instance.Backend-S1.id
  
}