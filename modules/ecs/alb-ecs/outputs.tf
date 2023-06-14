output "aws_alb_target_group" {
  value = aws_alb_target_group.app-tg.arn
}

output "aws_alb_ecs" {
  value = aws_alb.alb.arn
}

output "aws_alb_listener_ecs" {
  value = aws_alb_listener.app
}