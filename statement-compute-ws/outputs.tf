output "app_instance_id" {
  value = aws_instance.app.id
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "alb_dns_name" {
  value = aws_lb.service.dns_name
}

output "alb_zone_id" {
  value = aws_lb.service.zone_id
}

output "alb_arn" {
  value = aws_lb.service.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}
