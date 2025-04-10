 module "s3-statefile"{
   source ="./s3-bucket-m"
 }


 terraform {
   backend "s3" {
     bucket = "david-statefile-buc"
     key    = "my-terraform-project-statefile.tf"
     region = "us-east-1"
   }
}


# VPC Configuration
module "vpc" {
  source    = "./vpc-m"
  vpc_cider = "10.0.0.0/16"
}

# Subnet Configuration
module "subnet_configuration" {
  source = "./subnet-m"
  vpc_id = module.vpc.vid

  cidr_b_1 = "10.0.0.0/24"
  cidr_b_2 = "10.0.1.0/24"
  cidr_b_3 = "10.0.2.0/24"
  cidr_b_4 = "10.0.3.0/24"
}

# Security Group for Public Subnet
module "security_group_public" {
  source = "./security_group-m"
  vpc_id = module.vpc.vid
}

# Internet Gateway and Routes
module "internet_gateway_and_routes" {
  source               = "./route-m"
  vpc_id               = module.vpc.vid
  public_subnet_AZ1_id = module.subnet_configuration.public_subnetAZ1_id
  public_subnet_AZ2_id = module.subnet_configuration.public_subnetAZ2_id
}

# Application Load Balancer
module "application_load_balancer" {
  source             = "./lb-m"
  vpc_id             = module.vpc.vid
  public_sub_AZ1_id  = module.subnet_configuration.public_subnetAZ1_id
  public_sub_AZ2_id  = module.subnet_configuration.public_subnetAZ2_id
  private_sub_AZ1_id = module.subnet_configuration.private_subnetAZ1_id
  private_sub_AZ2_id = module.subnet_configuration.private_subnetAZ2_id
}

# EC2 Instances
module "ec2_instances" {
  source              = "./instances-m"
  public_sub_AZ1_id   = module.subnet_configuration.public_subnetAZ1_id
  public_sub_AZ2_id   = module.subnet_configuration.public_subnetAZ2_id
  private_sub_AZ1_id  = module.subnet_configuration.private_subnetAZ1_id
  private_sub_AZ2_id  = module.subnet_configuration.private_subnetAZ2_id
  security_group      = module.security_group_public.security_group
  public_alb_tg_arn   = module.application_load_balancer.public_alb_tg_arn
  internal_alb_tg_arn = module.application_load_balancer.internal_alb_tg_arn
}


