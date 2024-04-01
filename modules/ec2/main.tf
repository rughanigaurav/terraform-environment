resource "aws_instance" "jump-server" {

    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    security_groups = [var.test_security_group_id]
    key_name = "test"
    subnet_id = var.public_subnet_az1_id

    root_block_device {
      
      volume_size = 20
      volume_type = gp2

    }
  
  tags = {
    Name = "jump-server"
  }
}
resource "aws_instance" "Frontend-S1" {

    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    security_groups = var.aws_security_group.test_security_group_id
    key_name = "test"
    subnet_id = var.private_subnet_az1_id
    user_data = file(install_app.sh)

    root_block_device {
      
      volume_size = 30
      volume_type = gp2
    }
    
  tags = {
    Name = "Frontend-S1"
  }


}

resource "aws_instance" "Backend-S1" {

    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.micro"
    security_groups = var.test_security_group_id
    key_name = "test"
    subnet_id = var.private_subnet_az1_id
    user_data = file(install_app.sh)

    root_block_device {
      
      volume_size = 30
      volume_type = gp2
    }


    tags = {
      Name = "Backend-S1"
    }
}