data "aws_ami" "linux-ami" {
   most_recent = true
  filter {
    name = "name"
    values = [ "al2023-ami-2023.*" ]
  }
}


  # Instance: Apache Web Server (Public Subnet)
  resource "aws_instance" "public_ec2_AZ1" {
    ami                    = data.aws_ami.linux-ami.id
    instance_type          = "t3.micro"
    subnet_id              = var.public_sub_AZ1_id # Fixed reference to specific subnet
    vpc_security_group_ids = [var.security_group]
    key_name               = "David-key" # Reference the key pair name in AWS

    tags = {
      Name = "public_ec2_AZ1"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo yum install -y httpd",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "echo 'public_ec2_AZ1' | sudo tee /var/www/html/index.html"
      ]

      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("/home/david/David-key.pem") # Recommended path format
        host        = self.public_ip
      }
    }
  }

resource "aws_instance" "public_ec2_AZ2" {
    ami                    = data.aws_ami.linux-ami.id
    instance_type          = "t3.micro"
    subnet_id              = var.public_sub_AZ2_id # Fixed reference to specific subnet
    vpc_security_group_ids = [var.security_group]
    key_name               = "David-key" # Reference the key pair name in AWS

    tags = {
      Name = "public_ec2_AZ2"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo yum update -y",
        "sudo yum install -y httpd",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "echo 'public_ec2_AZ2' | sudo tee /var/www/html/index.html"
      ]

      connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file("/home/david/David-key.pem") # Recommended path format
        host        = self.public_ip
      }
    }
  }


  resource "aws_instance" "private_ec2_AZ1" {
    ami                    = data.aws_ami.linux-ami.id
    instance_type          = "t3.micro"
    subnet_id              = var.private_sub_AZ1_id # Fixed reference to specific subnet
    vpc_security_group_ids = [var.security_group]
    key_name               = "David-key" # Reference the key pair name in AWS

    tags = {
      Name = "private_ec2_AZ1"
    }

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "private_ec2_AZ1" > /var/www/html/index.html
                EOF
  }



  resource "aws_instance" "private_ec2_AZ2" {
    ami                    = data.aws_ami.linux-ami.id
    instance_type          = "t3.micro"
    subnet_id              = var.private_sub_AZ2_id# Fixed reference to specific subnet
    vpc_security_group_ids = [var.security_group]
    key_name               = "David-key" # Reference the key pair name in AWS

    tags = {
      Name = "private_ec2_AZ2"
    }

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd
                systemctl enable httpd
                echo "private_ec2_AZ2" > /var/www/html/index.html
                EOF
  }






  resource "aws_lb_target_group_attachment" "be_ws_1_attachment" {
    target_group_arn =var.public_alb_tg_arn
    target_id        = aws_instance.public_ec2_AZ1.id
    port             = 80
  }
  resource "aws_lb_target_group_attachment" "be_ws_2_attachment" {
    target_group_arn = var.public_alb_tg_arn
    target_id        = aws_instance.public_ec2_AZ2.id
    port             = 80
  }


  resource "aws_lb_target_group_attachment" "be_ws_3_attachment" {
    target_group_arn = var.internal_alb_tg_arn
    target_id        = aws_instance.private_ec2_AZ1.id
    port             = 80
  }
  resource "aws_lb_target_group_attachment" "be_ws_4_attachment" {
    target_group_arn = var.internal_alb_tg_arn
    target_id        = aws_instance.private_ec2_AZ2.id
    port             = 80
  }
