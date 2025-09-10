# ALB
resource "aws_alb" "alb" {
name = "application-load-balancer"
internal = false
security_groups = [var.sg_id]
subnets = var.subnets 
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


# Target Group (need to go for "Instance Target Group" in the official registry.terraform page for target groups)
# these 8080 port is configured without Apache, if Apache is configured, then we need to keep port 80 here
resource "aws_lb_target_group" "tg" {
name = "tg"
port = 80
protocol = "HTTP"
vpc_id = var.vpc_id
}


# Target Group Attachment
# these 8080 port is configured without Apache, if Apache is configured, then we need to keep port 80 here
resource "aws_lb_target_group_attachment" "tga" {
  count = length(var.instances)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.instances[count.index]
  port             = 80
}