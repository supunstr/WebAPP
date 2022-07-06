# creating security group for ELB and open port 443
resource "aws_security_group" "app-elb" {
  name        = "APP-ELB"
  description = "Allow ssh and http ports inbound and everything outbound"
  vpc_id      = aws_vpc.vpc-app.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name : "APP-ELB"
    Environment = "app"
    Terraform   = "true"
  }
}


# creating security group open ports 22 / 80
resource "aws_security_group" "app-forntend" {
  name        = "MAGRI-FRONTEND"
  description = "Allow ssh and http ports inbound and everything outbound"
  vpc_id      = aws_vpc.vpc-app.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.app-elb.id]
  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.app-elb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  tags = {
    Name : "APP-FRONTEND"
    Environment = "app"
    Terraform   = "true"
  }
}

resource "random_pet" "ami_random_name" {
  keepers = {
    # Generate a new pet name every time we change the AMI
    ami-id = var.ami-id
  }
}

# Creating AutoScaling template
resource "aws_launch_template" "app_template" {
  name_prefix            = "APP-TEMPLATE"
  image_id               = var.ami-id
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.app-forntend.id]
  instance_type          = var.instance-type
  user_data              = filebase64("terraform/user_data.sh")

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 30
      encrypted   = true
    }
  }

  block_device_mappings {
    device_name = "/dev/sdb"

    ebs {
      volume_size = 15
      encrypted   = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"

  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.app_profile.arn
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name : "APP-TEMPLATE"
    Environment = "app"
    Terraform   = "true"
  }
}

resource "aws_autoscaling_group" "app_group" {
  name_prefix               = "app-asg-${random_pet.ami_random_name.id}"
  vpc_zone_identifier       = [aws_subnet.pubsub01.id, aws_subnet.pubsub02.id]
  desired_capacity          = var.desired
  max_size                  = var.max
  min_size                  = var.min
  health_check_grace_period = 600
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.app-group.arn, aws_lb_target_group.app-group-backend.arn]

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "APP-EC2"
    propagate_at_launch = true
  }

}

##resource "aws_autoscaling_attachment" "magri_autoscating" {
## autoscaling_group_name = aws_autoscaling_group.magri_group.id
##lb_target_group_arn    = aws_lb_target_group.magri-group.arn
#  id                = "magri-asg-${random_pet.ami_random_name.id}"
# elb                    = aws_lb.magri-alb.id
##}

resource "aws_autoscaling_policy" "app_policy_up" {
  name                   = "APP-POLICY-UP"
  scaling_adjustment     = var.scaling_adjustment_up
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.magri_group.id
}
resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_up" {
  alarm_name          = "APP-CPU-ALARM-UP"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_up
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_group.id
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_policy_up.arn]
}
resource "aws_autoscaling_policy" "app_policy_down" {
  name                   = "APP-POLICY-DOWN"
  scaling_adjustment     = var.scaling_adjustment_down
  adjustment_type        = var.adjustment_type
  cooldown               = var.cooldown
  autoscaling_group_name = aws_autoscaling_group.app_group.id
}
resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_down" {
  alarm_name          = "APP-CPU-ALARM-DOWN"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold_down
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_group.id
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.app_policy_down.arn]
}
