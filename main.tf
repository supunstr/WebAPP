provider "aws" {
  region  = var.region
  profile = "default"
}

# creating security group for ELB and open port 443
resource "aws_security_group" "magri-elb" {
  name        = "MAGRI-ELB"
  description = "Allow ssh and http ports inbound and everything outbound"
  vpc_id      = aws_vpc.vpc-mAgri.id

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
    Name : "MAGRI-ELB"
  }
}


# creating security group open ports 22 / 80
resource "aws_security_group" "magri-forntend" {
  name        = "MAGRI-FRONTEND"
  description = "Allow ssh and http ports inbound and everything outbound"
  vpc_id      = aws_vpc.vpc-mAgri.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.magri-elb.id]
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
    Name : "MAGRI-FRONTEND"
  }
}

# Creating ELB
#resource "aws_elb" "magri_elb" {
#  name            = "MAGRI-ELB"
#  subnets         = [aws_subnet.pubsub01.id, aws_subnet.pubsub02.id]
#  security_groups = [aws_security_group.magri-elb.id]

# listener {
#   instance_port     = 80
#   instance_protocol = "http"
#   lb_port           = 80
#   lb_protocol       = "http"
#}
#tags = {
#  Name : "MAGRI-ELB"
#}
#}

resource "random_pet" "ami_random_name" {
  keepers = {
    # Generate a new pet name every time we change the AMI
    ami-id = var.ami-id
  }
}

# Creating AutoScaling template
resource "aws_launch_template" "magri_template" {
  name_prefix            = "MAGRI-TEMPLATE"
  image_id               = var.ami-id
  key_name               = var.key
  vpc_security_group_ids = [aws_security_group.magri-forntend.id]
  instance_type          = var.instance-type

  iam_instance_profile {
    arn = aws_iam_instance_profile.magri_profile.arn
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name : "MAGRI-TEMPLATE"
  }
}

resource "aws_autoscaling_group" "magri_group" {
  name_prefix         = "magri-asg-${random_pet.ami_random_name.id}"
  vpc_zone_identifier = [aws_subnet.pubsub01.id, aws_subnet.pubsub02.id]
  desired_capacity    = var.desired
  max_size            = var.max
  min_size            = var.min
  target_group_arns = [aws_lb_target_group.magri-group.arn]

  launch_template {
    id      = aws_launch_template.magri_template.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

##resource "aws_autoscaling_attachment" "magri_autoscating" {
 ## autoscaling_group_name = aws_autoscaling_group.magri_group.id
  ##lb_target_group_arn    = aws_lb_target_group.magri-group.arn
  #  id                = "magri-asg-${random_pet.ami_random_name.id}"
  # elb                    = aws_lb.magri-alb.id
##}