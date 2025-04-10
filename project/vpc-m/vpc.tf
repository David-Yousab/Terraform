resource "aws_vpc" "VPC_project" {
    cidr_block = var.vpc_cider
    tags = {
      Name = "VPC_project"
    }
  }
