resource "aws_alb" "alb" {
  name           = "AlbEcs${var.project_name}"
  subnets        = var.subnets_alb
  security_groups = [var.security_group_alb]
  tags = {
    Type: "Terraform"
  }
}

resource "aws_alb_target_group" "app-tg" {
  name        = "TargetGroup${var.project_name}"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.id_vpc
  tags = {
    Type: "Terraform"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/"
    interval            = 30
  }
}

resource "aws_alb_listener" "app" {
  load_balancer_arn = aws_alb.alb.id
  port              = var.app_port
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app-tg.arn
  }
}
