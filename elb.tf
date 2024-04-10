# Create Target Group
resource "aws_lb_target_group" "cloudhight_target_group" {
  name     = "docker-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudhight_vpc.id

  health_check {
    protocol                    = "HTTP"
    port                        = 80
    path                        = "/"
    timeout                     = 5
    interval                    = 30
    healthy_threshold           = 2
    unhealthy_threshold         = 2
  }
}

 # Create an application load balancer
resource "aws_lb" "cloudhight_lb" {
  name               = "cloudhight-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet2.id]
  depends_on         = [aws_internet_gateway.gw]
}


resource "aws_lb_listener" "cloudhight_lb-listner" {
  load_balancer_arn = aws_lb.cloudhight_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cloudhight_target_group.arn
  }
}