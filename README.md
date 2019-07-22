# aws-terraform
my first terraform aws IaaC

prerequisites

AWS account
create a user with VPC and EC2 IAM credentials
create keypair for ssh access
install terraform on your workstation and set path
download the ssh keypair created above to connect to instance


This code will create following resources in AWS Mumbai region

VPC with metioned CIDR
3 public and 3 private subnets with mentioned range
security groups for ssh/http/https access
RHEL instance with AMI mentioned

steps to provision infra
set env variable on your workstation
export AWS_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY
download the main.cf file in the new directory
terraform plan
terraform apply


This code outputs EC2 instance ID and pubic IP

ssh -i keypair.pem ec2-user@publicipofinstancce


