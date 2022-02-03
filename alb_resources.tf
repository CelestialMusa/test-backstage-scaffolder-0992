data "aws_acm_certificate" "softeng_imported_ssl_cert" {
  domain   = var.site_domain
  statuses = ["ISSUED"]
}

resource "aws_lb_target_group" "softeng_web_tg" {
  name        = local.web_tg_name
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "5"
    path                = var.web_health_check_path
    unhealthy_threshold = "2"
  }

  tags = merge(
    tomap({ "Name" : local.web_tg_name }),
    local.tags
  )
}

resource "aws_lb_target_group" "softeng_api_tg" {
  name        = local.api_tg_name
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "5"
    path                = var.api_health_check_path
    unhealthy_threshold = "2"
  }

  tags = merge(
    tomap({ "Name" : local.api_tg_name }),
    local.tags
  )
}

resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.softeng_elastic_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.softeng_imported_ssl_cert.arn

  default_action {
    target_group_arn = aws_lb_target_group.softeng_web_tg.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.alb_https_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.softeng_api_tg.arn
  }

  condition {
    path_pattern {
      values = ["*/api/*"]
    }
  }
}

resource "aws_lb" "softeng_elastic_load_balancer" {
  name               = local.alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.softeng_web_allow_tls.id}"]
  subnets            = var.app_subnets

  tags = merge(
    tomap({ "Name" : local.alb_name }),
    local.tags
  )
}