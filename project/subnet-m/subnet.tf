 resource "aws_subnet" "public_subnet_AZ1" {
    vpc_id                  = var.vpc_id 
    cidr_block              = var.cidr_b_1
    map_public_ip_on_launch = true
    availability_zone       = var.AZ1
    tags = {
      Name = "public_subnet_AZ1"
    }
  }



  resource "aws_subnet" "private_subnet_AZ1" {
    vpc_id                  = var.vpc_id 
    cidr_block              = var.cidr_b_3

    availability_zone       = var.AZ1
    tags = {
      Name = "private_subnet_AZ1"
    }
  }



resource "aws_subnet" "public_subnet_AZ2" {
    vpc_id                  = var.vpc_id 
    cidr_block              = var.cidr_b_2
    map_public_ip_on_launch = true
    availability_zone       = var.AZ2
    tags = {
      Name = "public_subnet_AZ2"
    }
  }

  


  resource "aws_subnet" "private_subnet_AZ2" {
    vpc_id                  = var.vpc_id 
    cidr_block              = var.cidr_b_4

    availability_zone       = var.AZ2
    tags = {
      Name = "private_subnet_AZ2"
    }
  }

