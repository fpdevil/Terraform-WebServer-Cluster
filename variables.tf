variable "ami" {
  description = "AMI identifier to be used"
  type        = string
  default     = "ami-04f167a56786e4b09"
}

variable "instance_type" {
  description = "Type of Machine to be used"
  type        = string
  default     = "t2.micro"
}


variable "ssh_port" {
  description = "The port which server allows SSH requests"
  type        = number
  default     = 22
}

variable "server_port" {
  description = "The port which server allows HTTP requests"
  type        = number
  default     = 8080
}

variable "alb_name" {
  description = "The new ALB to be created"
  type        = string
  default     = "terraform-poc-alb"
}

variable "alb_port_http" {
  description = "The HTTP Port on which the ALB url will be exposed"
  type = number
  default = 80
}

variable "instance_security_group_name" {
  description = "Name of the security group to be attached to the EC2 instance"
  type        = string
  default     = "terraform-poc-webserver-sg"
}

variable "alb_security_group_name" {
  description = "Name of the security group to be attached to the ALB instance"
  type        = string
  default     = "terraform-poc-alb-sg"
}

variable "alb_target_group_name" {
  description = "Name of the Target Group to be attached to the ALB"
  type        = string
  default     = "terraform-poc-alb-targetgrp"
}

variable "aws_autoscaling_group_name" {
  description = "Name of the AWS ASG Group"
  type        = string
  default     = "poc-tf-asg"
}

variable "vpc_cidr_block" {
  description = "The VPC CIDR block used in Instance Security group ingress rules"
  type        = string
  default     = "0.0.0.0/0"
}
