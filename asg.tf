resource "aws_launch_template" "cloudhight" {
  name_prefix   = "example"
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.lb_sg.id]
  user_data = filebase64("./userdata.sh")
    key_name      = "cloudhight-assessment"
iam_instance_profile {
  arn = aws_iam_instance_profile.example_profile.arn
#   name = aws_iam_instance_profile.example_profile.name
}

}


#Autoscalong
resource "aws_autoscaling_group" "example" {
  name = "cloudhight"

  capacity_rebalance  = true
  desired_capacity    = 1
   load_balancers = [
    "${aws_elb.web_elb.id}"
  ]
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 25
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.cloudhight.id
      }

      override {
        instance_type     = var.instance_type
        weighted_capacity = "3"
      }

      override {
        instance_type     = "c3.large"
        weighted_capacity = "2"
      }
    }
  }


}



#Monitoring
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "test_scale_down"
  autoscaling_group_name = aws_autoscaling_group.example.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "test_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "25"
  evaluation_periods  = "5"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name = "web_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.example.name
}