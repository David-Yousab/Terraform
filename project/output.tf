output "public_ec2_AZ1_ip" {
  description = "public_ec2_ip"
   value = module.ec2_instances.public_ec2_AZ1_ip
  
}

output "public_ec2_AZ2_ip" {
  description = "public_ec2_ip"
   value = module.ec2_instances.public_ec2_AZ2_ip
  
}
output "private_ec2_AZ1_ip" {
  description = "private_ec2_ip"
   value = module.ec2_instances.private_ec2_AZ1_ip
  
}

output "private_ec2_AZ2_ip" {
  description = "private_ec2_ip"
   value = module.ec2_instances.private_ec2_AZ2_ip
  
}
