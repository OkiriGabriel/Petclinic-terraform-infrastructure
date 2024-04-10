# Create Target Group
resource "aws_lb_target_group" "docker_target_group" {
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

# Create Load Balancer
resource "aws_lb" "docker_lb" {
  name               = "docker-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet2.id ]
  
  # Define listener
  enable_deletion_protection = false # Optionally set deletion protection
  enable_cross_zone_load_balancing = true # Optionally enable cross-zone load balancing


}

#Loadbalancer
resource "aws_elb" "web_elb" {
  name = "web-elb"
  security_groups = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet2.id]
cross_zone_load_balancing   = true
health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
listener {
    lb_port = 8080
    lb_protocol = "http"
    instance_port = "8080"
    instance_protocol = "http"
  }
}