# Terraform POC for AWS ASG
A very simple `terraform` poc for creating `EC2` instances configured under an `ALB`. The included `terraform` scripts are a way to create all the infrastructure automatically as per the `IaC` principle.

The shell script `launch_httpd.sh` creates a `http` server for testing the whole setup through browser.

```bash
#  Terraform Initialize
## Initialize the local backend
## Download the plugins from provider
terraform init

#  Terrafom Validate
## Checks for changes in files and prints them to stdout
terraform validate

#  Terraform Plan
## It just prints the execution plan
terraform plan

#  Terraform Apply
## Creates resources on the cloud
## Creates terraform.tfstate file
terraform apply -auto-approve
```

# Creation

```bash
$ terraform apply
data.aws_vpc.default: Reading...
data.aws_vpc.default: Read complete after 0s [id=vpc-0beb539d9a8a1f08e]
data.aws_subnets.default: Reading...
data.aws_subnets.default: Read complete after 0s [id=us-east-2]
...
...
...
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_security_group.allow_http_ssh: Creating...
aws_security_group.poc_alb_asg: Creating...
aws_alb_target_group.poc_alb_tgrp: Creating...
aws_alb_target_group.poc_alb_tgrp: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:targetgroup/terraform-poc-alb-targetgrp/bacdb1010d6be036]
aws_security_group.allow_http_ssh: Creation complete after 2s [id=sg-0bbcccf1b513249fc]
aws_launch_template.poc_launch_template: Creating...
aws_security_group.poc_alb_asg: Creation complete after 2s [id=sg-04ebbb8a1b6877a2e]
aws_alb.poc_alb: Creating...
aws_launch_template.poc_launch_template: Creation complete after 6s [id=lt-057286aad8ddbbfea]
aws_autoscaling_group.poc_asg: Creating...
aws_alb.poc_alb: Still creating... [10s elapsed]
aws_autoscaling_group.poc_asg: Still creating... [10s elapsed]
aws_alb.poc_alb: Still creating... [20s elapsed]
aws_autoscaling_group.poc_asg: Creation complete after 16s [id=terraform-20250326184218044600000003]
aws_alb.poc_alb: Still creating... [30s elapsed]
aws_alb.poc_alb: Still creating... [40s elapsed]
...
...
aws_alb.poc_alb: Still creating... [3m0s elapsed]
aws_alb.poc_alb: Creation complete after 3m3s [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:loadbalancer/app/terraform-poc-alb/d95a4ac8eb17f8da]
aws_alb_listener.poc_alb_http: Creating...
aws_alb_listener.poc_alb_http: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:listener/app/terraform-poc-alb/d95a4ac8eb17f8da/783e3bdd4c824abe]
aws_alb_listener_rule.poc_alb_listener_rule: Creating...
aws_alb_listener_rule.poc_alb_listener_rule: Creation complete after 0s [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:listener-rule/app/terraform-poc-alb/d95a4ac8eb17f8da/783e3bdd4c824abe/7064ca935be558b5]

Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

alb_dns_name = "terraform-poc-alb-1513312962.us-east-2.elb.amazonaws.com"
autoscaling_group_arn = "arn:aws:autoscaling:us-east-2:586794471533:autoScalingGroup:afb48620-f9c8-4e91-9bd5-70f316d5083f:autoScalingGroupName/terraform-20250326184218044600000003"
autoscaling_group_id = "terraform-20250326184218044600000003"
autoscaling_group_name = "terraform-20250326184218044600000003"
launch_template_id = "lt-057286aad8ddbbfea"
launch_template_latest_version = 1
```

## Test
Capture the `ALB` address from the output of `terraform` above and use that to test through browser or `curl`.
```bash
$ curl http://terraform-poc-alb-1513312962.us-east-2.elb.amazonaws.com
```

# Cleanup

```bash
# Terraform Destroy
terraform destroy -auto-approve

# Clean-Up Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

Destroying the infrastructure
```sh
$ terraform destroy
data.aws_vpc.default: Reading...
aws_security_group.poc_alb_asg: Refreshing state... [id=sg-04ebbb8a1b6877a2e]
aws_security_group.allow_http_ssh: Refreshing state... [id=sg-0bbcccf1b513249fc]
aws_launch_template.poc_launch_template: Refreshing state... [id=lt-057286aad8ddbbfea]
data.aws_vpc.default: Read complete after 1s [id=vpc-0beb539d9a8a1f08e]
data.aws_subnets.default: Reading...
aws_alb_target_group.poc_alb_tgrp: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:targetgroup/terraform-poc-alb-targetgrp/bacdb1010d6be036]
data.aws_subnets.default: Read complete after 0s [id=us-east-2]
aws_alb.poc_alb: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:loadbalancer/app/terraform-poc-alb/d95a4ac8eb17f8da]
aws_autoscaling_group.poc_asg: Refreshing state... [id=terraform-20250326184218044600000003]
aws_alb_listener.poc_alb_http: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:listener/app/terraform-poc-alb/d95a4ac8eb17f8da/783e3bdd4c824abe]
aws_alb_listener_rule.poc_alb_listener_rule: Refreshing state... [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:listener-rule/app/terraform-poc-alb/d95a4ac8eb17f8da/783e3bdd4c824abe/7064ca935be558b5]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy
...
...
aws_security_group.poc_alb_asg: Destroying... [id=sg-04ebbb8a1b6877a2e]
aws_security_group.poc_alb_asg: Destruction complete after 1s
aws_autoscaling_group.poc_asg: Still destroying... [id=terraform-20250326184218044600000003, 40s elapsed]
...
...
aws_autoscaling_group.poc_asg: Still destroying... [id=terraform-20250326184218044600000003, 6m50s elapsed]
aws_autoscaling_group.poc_asg: Destruction complete after 6m52s
aws_alb_target_group.poc_alb_tgrp: Destroying... [id=arn:aws:elasticloadbalancing:us-east-2:586794471533:targetgroup/terraform-poc-alb-targetgrp/bacdb1010d6be036]
aws_launch_template.poc_launch_template: Destroying... [id=lt-057286aad8ddbbfea]
aws_alb_target_group.poc_alb_tgrp: Destruction complete after 0s
aws_launch_template.poc_launch_template: Destruction complete after 0s
aws_security_group.allow_http_ssh: Destroying... [id=sg-0bbcccf1b513249fc]
aws_security_group.allow_http_ssh: Destruction complete after 1s
```
