#Create Elastic IP for AZ1
resource "aws_eip" "eip_for_nat_gateway_az1" {

    domain = "vpc"
   tags = {
      Name = "nat gateway for az1 eip"
    }
}

#Create Elastic IP for AZ2
resource "aws_eip" "eip_for_nat_gateway_az2" {

    domain = "vpc"

    tags = {
      Name = "nat gateway for az2 eip"
    }  
}

#Create Nat-Gateway for AZ1

resource "aws_nat_gateway" "nat_gateway_az1" {

    allocation_id   = aws_eip.eip_for_nat_gateway_az1.id 
    subnet_id       = var.public_subnet_az1_id # (called from VPC module output.tf file --> you need to create variable in this module)

    tags = {
      Name = "nat gateway az1" 
    }

    depends_on = [var.internet_gateway] # (called from VPC module output.tf file --> you need to create variable in this module)
}

#Create Nat-Gateway for AZ2
resource "aws_nat_gateway" "nat_gateway_az2" {

    allocation_id   = aws_eip.eip_for_nat_gateway_az2.id 
    subnet_id       = var.public_subnet_az2_id # (called from VPC module output.tf file --> you need to create variable in this module)

    tags = {
      Name = "nat gateway az2" 
    }

    depends_on = [var.internet_gateway] # (called from VPC module output.tf file --> you need to create variable in this module)
}

#Create route table for AZ1
resource "aws_route_table" "private_route_table_az1" {
  
  vpc_id = var.vpc_id # (called from VPC module output.tf file --> you need to create variable in this module)

  route = [{

    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = "aws_nat_gateway.nat_gateway_az1.id"
    carrier_gateway_id = ""
    core_network_arn = ""
    destination_prefix_list_id = ""
    egress_only_gateway_id = ""
    gateway_id = ""
    ipv6_cidr_block = "::/0"
    local_gateway_id = ""
    network_interface_id = ""
    transit_gateway_id = ""
    vpc_endpoint_id = ""
    vpc_peering_connection_id = ""

  }]

  tags = {

    Name = "Private route table az1"
  }  

}
resource "aws_route_table" "private_route_table_az2" {
  
  vpc_id = var.vpc_id # (called from VPC module output.tf file --> you need to create variable in this module)

  route = [{

    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
    carrier_gateway_id = ""
    destination_prefix_list_id = ""
    core_network_arn = ""
    egress_only_gateway_id = ""
    gateway_id = ""
    ipv6_cidr_block = "::/0"
    local_gateway_id = ""
    network_interface_id = ""
    transit_gateway_id = ""
    vpc_endpoint_id = ""
    vpc_peering_connection_id = ""

  }]

  tags = {

    Name = "Private route table az2"
  }  
}

#Private Route Table Association for AZ1
resource "aws_route_table_association" "private_az1_association" {
  
    subnet_id = var.private_subnet_az1_id # (called from VPC module output.tf file --> you need to create variable in this module)
    route_table_id = aws_route_table.private_route_table_az1

}

#Private Route Table Association for AZ2
resource "aws_route_table_association" "private_az2_association" {
  
    subnet_id = var.private_subnet_az2_id # (called from VPC module output.tf file --> you need to create variable in this module)
    route_table_id = aws_route_table.private_route_table_az2.id

}