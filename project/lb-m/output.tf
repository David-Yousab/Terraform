output "public_alb_tg_arn" {
  value = aws_lb_target_group.public_alb_tg.arn
}

output "internal_alb_tg_arn" {
  value = aws_lb_target_group.internal_alb_tg.arn
}