output "target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}

output "dns_name" {
  value = aws_lb.alb.dns_name
}

output "zone_id" {
  value = aws_lb.alb.zone_id
}
