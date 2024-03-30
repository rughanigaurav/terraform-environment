# terraform aws create security group
resource "aws_security_group" "security_group" {
  name        = "prolix-SG"
  description = "Apply security to access servers"
  vpc_id      = aws_vpc.vpc.id
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
    description      = "Allow-SSH-From-ThaiOffice"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["74.103.179.108/32"]
  }

  ingress {

    description     = "Allow-Postgres-From-Prolix"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["103.105.233.106/32"] 

  }

    ingress {

    description     = "Allow-Postgres-From-Prolix"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    cidr_blocks     = ["74.103.179.108/32"] 

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