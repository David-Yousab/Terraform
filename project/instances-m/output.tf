output "public_ec2_AZ1_ip" {
  description = "Public IP of EC2 in AZ1"
  value       = aws_instance.public_ec2_AZ1.public_ip
}

output "public_ec2_AZ2_ip" {
  description = "Public IP of EC2 in AZ2"
  value       = aws_instance.public_ec2_AZ2.public_ip
}

output "private_ec2_AZ1_ip" {
  description = "Private IP of EC2 in AZ1"
  value       = aws_instance.private_ec2_AZ1.private_ip
}

output "private_ec2_AZ2_ip" {
  description = "Private IP of EC2 in AZ2"
  value       = aws_instance.private_ec2_AZ2.private_ip
}
