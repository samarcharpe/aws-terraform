# aws-terraform
my first terraform aws IaaC

prerequisites

AWS account
create a user with VPC and EC2 IAM credentials
create keypair for ssh access


This code will create following resources in AWS Mumbai region

VPC with metioned CIDR
3 public and 3 private subnets with mentioned range
security groups for ssh/http/https access
RHEL instance with AMI mentioned

This code outputs EC2 instance ID and pubic IP


