# Terraform output values
# Replace the public_ip output with DNS from ALB
output "alb_dns_name" {
  value       = aws_alb.poc_alb.dns_name
  description = "The DNS name of the Load Balancer to access"
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.poc_launch_template.id
}

output "launch_template_latest_version" {
  description = "Launch Template Latest Version"
  value       = aws_launch_template.poc_launch_template.latest_version
}

# Autoscaling Outputs
output "autoscaling_group_id" {
  description = "Autoscaling Group ID"
  value       = aws_autoscaling_group.poc_asg.id
}

output "autoscaling_group_name" {
  description = "Autoscaling Group Name"
  value       = aws_autoscaling_group.poc_asg.name
}

output "autoscaling_group_arn" {
  description = "Autoscaling Group ARN"
  value       = aws_autoscaling_group.poc_asg.arn
}
