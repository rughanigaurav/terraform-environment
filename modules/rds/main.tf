resource "aws_security_group" "security_group" {
  name_prefix = "rds-sg-"
  description = "Security group for RDS instance"
  
  vpc_id = var.vpc_id

  // Add your security group rules here
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "db-subnet-group" {
    
    name = "kg-subnet"
    subnet_ids = [var.private_subnet_az1_cidr,var.private_subnet_az2_cidr,var.public_subnet_az1_cidr,var.public_subnet_az2_cidr ]
    description = "Subnet for RDS"
    tags = {
      
      Name = "default-vpc-0217757ec8c0923c7"
    } 
}

data "aws_availability_zones" "available_zones" {}

resource "aws_db_instance" "db-instance" {
    
    instance_class = "${var.database-instance-class}"
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    identifier = "my-postgres-db"
    db_subnet_group_name = aws_db_subnet_group.db-subnet-group
    multi_az = false
    vpc_security_group_ids = [aws_security_group.security_group.id]
    username = "Pr0l1x_Admin"
    password = "2tVkHZ4cYaUo66DLRinM"
    allocated_storage = 20
    storage_type = "gp2"
    engine = "postgres"
    engine_version = "15.5"
    performance_insights_enabled = false
    port = 3306
    publicly_accessible = true

    skip_final_snapshot = true
}