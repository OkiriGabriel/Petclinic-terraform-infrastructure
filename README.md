## Pet Clinic Application

## Tools used
  1 Terraform
  2 Github
  3 Jenkins
  4 AWS 
  5 Java

## Terraform Infrastructure Documentation: Infrastructure Setup for Dockerized Pet Clinic Application
-- This documentation guides you through setting up the infrastructure using Terraform to deploy a Dockerized Pet Clinic application on AWS. The infrastructure includes an Auto Scaling Group (ASG) to manage EC2 instances, a security group to control inbound and outbound traffic, and associated configurations.
# Link to the terraform infrastructure - 

[https://www.youtube.com/@cloudchamp?
](https://www.youtube.com/@cloudchamp?sub_confirmation=1)
# Prerequisites
- AWS account credentials with appropriate permissions.
- Terraform installed on your local machine.

- Step 1: Organize Terraform Files
- Organize your Terraform configuration files into a structured format:

```
terraform/
    ├── main.tf
    ├── asg.tf
    ├── sg.tf
    └── variables.tf
```
```
main.tf: Main configuration file.
asg.tf: Auto Scaling Group configuration.
sg.tf: Security group configuration.
variables.tf: Variables used in the configuration.
```

- Step 2: Define Auto Scaling Group (ASG)
- Define the Auto Scaling Group (ASG) resource in asg.tf. This resource manages the scaling of EC2 instances based on defined conditions such as minimum and maximum instances:

```
resource "aws_autoscaling_group" "petclinic_asg" {
  # Define ASG configurations here
}
```

# Step 3: Define Launch Configuration
- Define the launch configuration for the ASG in asg.tf. This configuration includes specifications such as AMI, instance type, and security groups:

```
resource "aws_launch_configuration" "petclinic_lc" {
  # Define launch configuration here
}
```
- Step 4: Define Security Group
- Define the security group in sg.tf. This resource controls inbound and outbound traffic to the EC2 instances:
```
resource "aws_security_group" "petclinic_sg" {
  # Define security group configurations here
}
```

- Step 5: Define Variables
- Define the variables used in your Terraform configuration in variables.tf. These variables provide flexibility and reusability:

```
variable "instance_ami" {
  description = "AMI ID for the EC2 instance"
}
```
- Define other variables as needed

- Step 6: Terraform Initialization
- Initialize Terraform in your project directory:

```
terraform init
``` 
- Step 7: Terraform Plan
- Generate and review an execution plan to ensure that Terraform will create the desired infrastructure:

```
terraform plan
```
- Step 8: Terraform Apply
- Apply the Terraform configuration to create the infrastructure:

```
terraform apply
```
- Step 9: Deploy Dockerized Pet Clinic Application
- Deploy your Dockerized Pet Clinic application on the EC2 instances provisioned by the ASG.