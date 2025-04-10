resource "aws_security_group" "pri_alb" {
    vpc_id = var.vpc_id
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "priv_alb-prog"
    }
  }



  resource "aws_security_group" "alb" {
    vpc_id = var.vpc_id
    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "alb-prog"
    }
  }


  resource "aws_lb" "public_alb" {
    name               = "public-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb.id]
    subnets            = [var.public_sub_AZ1_id,var.public_sub_AZ2_id]

    enable_deletion_protection = false # Set to true for production

    tags = {
      Name = "public-alb"
    }
  }


   resource "aws_lb_target_group" "public_alb_tg" {
    name     = "public-alb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
      path                = "/"
      interval            = 30
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }


   resource "aws_lb_listener" "public_alb_listener" {
    load_balancer_arn = aws_lb.public_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.public_alb_tg.arn
    }
  }


  resource "aws_lb" "internal_alb" {
    name               = "intalb"
    internal           = true
    load_balancer_type = "application"
    security_groups    = [aws_security_group.pri_alb.id]
    subnets            = [var.private_sub_AZ1_id,var.private_sub_AZ2_id]

    enable_deletion_protection = false # Set to true for production

    tags = {
      Name = "internal-alb"
    }
  }


  resource "aws_lb_target_group" "internal_alb_tg" {

    name     = "internal-alb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
      path                = "/"
      interval            = 30
      timeout             = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }


  resource "aws_lb_listener" "internal_alb_listener" {
    load_balancer_arn = aws_lb.internal_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.internal_alb_tg.arn
    }

  }