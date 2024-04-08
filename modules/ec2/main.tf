resource "aws_instance" "jump-server" {

    ami = var.ami
    instance_type = var.instance_type
    security_groups = [var.test_security_group_id]
    key_name = "test"
    subnet_id = var.public_subnet_az1_id

    root_block_device {
      volume_size = 30
      volume_type = gp2
    }
  
  tags = {
    Name = "jump-server"
  }
}
resource "aws_instance" "Frontend-S1" {

    ami = var.ami
    instance_type = var.instance_type
    security_groups = var.aws_security_group.test_security_group_id
    key_name = "test"
    subnet_id = var.private_subnet_az1_id
    #user_data = file(install_app.sh)

    provisioner "remote-exec" {    #Installation of nodejs, caddy-server and supervisor service in frontend server

      inline = [ 
        "sudo apt update && sudo apt upgrade -y",
        "sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https",
        "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg",
        "curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list",
        "sudo apt update",
        "sudo apt install caddy -y",
        "sudo systemctl enable caddy && sudo systemctl start caddy",
        "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&",
        "sudo apt-get install -y nodejs",
        "sudo apt install supervisor -y"
       ]
      
    }
    root_block_device {
      volume_size = 30 
      volume_type = gp2 
    }
  tags = {
    Name = "Frontend-S1"
  }

}

variable "ami" {

  type = string
  default = "ami-047bb4163c506cd98"

}

variable "public_subnet_az1_id" {

  type = string
  default = "10.0.0.0/24"
 
}

variable "private_subnet_az1_id" {

  type = string
  default = "10.0.2.0/24"
  
}

resource "aws_instance" "Backend-S1" {

    ami = var.ami
    instance_type = var.instance_type
    security_groups = var.test_security_group_id
    key_name = "test"
    subnet_id = var.private_subnet_az1_id
    #user_data = file(install_app.sh)

    provisioner "remote-exec" { #Installation of nodejs, caddy-server and supervisor service in backend server

      inline = [ 
        "sudo apt update",
        "sudo apt upgrade -y",
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
        "sudo apt install -y supervisor"
       ]
      
    }

    root_block_device { 
      
      volume_size = 30
      volume_type = gp2
    }


    tags = {
      Name = "Backend-S1"
    }
}