variable "region" {
  description = "AWS region"
  default     = "eu-west-2" # Update with your desired region
}

variable "ami" {
  description = "EC2 instance AMI ID"
  default     = "ami-0b9932f4918a00c4f" # Update with your desired AMI ID
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.small" # Update with your desired instance type
}

variable "instance_class" {
  description = "RDS instance type"
  default     = "db.t2.micro" # Update with your desired instance type
}

variable "username" {
  description = "RDS instance username"
  default     = "admin" # Update with your desired username
}

variable "password" {
  description = "RDS instance password"
  default     = "password123" # Update with your desired password
}