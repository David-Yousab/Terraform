 resource "aws_internet_gateway" "igw" {
    vpc_id = var.vpc_id # Fixed reference from VPC_sog to VPC_project
    tags = {
      Name = "internet_gateway_project"
    }
  }
 

 
resource "aws_eip" "nat_eip" {
    tags = {
      "Name" = "eib"
    }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_AZ1_id
  tags = {
    "Name" = "ntg"
  }
}
 
 resource "aws_route_table" "public_route_table" {
    vpc_id = var.vpc_id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
    }
  }


   resource "aws_route_table_association" "associate_table1" {
    subnet_id      = var.public_subnet_AZ1_id
    route_table_id = aws_route_table.public_route_table.id
  }

  resource "aws_route_table_association" "associate_table2" {
    subnet_id      = var.public_subnet_AZ2_id # Added .id
    route_table_id = aws_route_table.public_route_table.id
  }

