# Resource: launch template configuration
# Acts as a blueprint for creating instances in the Auto Scaling Group
resource "aws_launch_template" "poc_launch_template" {
  name_prefix = "poc-tf-asg-"

  image_id      = var.ami_id
  instance_type = var.instance_type

  # security_groups = [aws_security_group.allow-http-ssh.id]
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  # Pass the user data as base64 encoded data
  user_data = base64encode(templatefile("${path.module}/launch_httpd.sh", { server_port = var.server_port }))

  # Required when using a launch configuration with an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}

# Resource: ASG Instance
# Create Auto Scaling Group
resource "aws_autoscaling_group" "poc_asg" {
  min_size = 2
  max_size = 10

  # Mainly for EC2 instances, this conflicts with vpc_zone_identifier
  # availability_zones = ["us-east-2"]

  vpc_zone_identifier = data.aws_subnets.default.ids

  # launch_configuration = aws_launch_template.poc_launch_template.name
  launch_template {
    # Refer to the launch template by its ID
    id = aws_launch_template.poc_launch_template.id

    # Use the latest version of launch template
    version = "$Latest"
  }

  # pick dynamically scaled ec2 insatnces using the ARN
  target_group_arns = [aws_alb_target_group.poc_alb_tgrp.arn]
  health_check_type = "ELB" # EC2 is minimal health check type

  tag {
    key                 = "Name"
    value               = var.aws_autoscaling_group_name
    propagate_at_launch = true
  }
}

# Resource: HTTP Listener for ALB
# Refer the security group configured for ALB in this
resource "aws_alb_listener" "poc_alb_http" {
  load_balancer_arn = aws_alb.poc_alb.arn
  port              = var.alb_port_http
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 Page Not Found!"
      status_code  = 404
    }
  }
}

# Resource: Listener Rules
# Create Listener rules for Load Balancer to match traffic of any
# pattern '*' to the target group containing the ASG
resource "aws_alb_listener_rule" "poc_alb_listener_rule" {
  listener_arn = aws_alb_listener.poc_alb_http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.poc_alb_tgrp.arn
  }
}

# Resource: Security Group for EC2 - For Web & SSH Traffic
resource "aws_security_group" "allow_http_ssh" {
  name        = var.instance_security_group_name
  description = "Security Group for Web Server EC2 instance allow SSH + HTTP"

  ingress {
    description = "Allow SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    description = "Allow Inbound HTTP"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

# Data source: VPC
data "aws_vpc" "default" {
  default = true
}

# Data source: subnet
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Resource:  Application Load Balancer
# Refer the ALB security group to allow inbound HTTP/80 and any outbound
resource "aws_alb" "poc_alb" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.poc_alb_asg.id]
}

# Resource: Security Group for ALB
# ALB by default does not allow any incoming or outgoing traffic and
# hence we need to create new security group specifically for ALB
# Allow Incoming over HTTP/80
# Allow Outgoing over all ports
resource "aws_security_group" "poc_alb_asg" {
  name = var.alb_security_group_name

  # Allow inbound requests on HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Allow outbound requests for all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }
}

# Resource: Target Group for ALB
resource "aws_alb_target_group" "poc_alb_tgrp" {
  name     = var.alb_target_group_name
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
