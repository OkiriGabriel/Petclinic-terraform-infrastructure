

# Create a VPC
resource "aws_vpc" "cloudhight_vpc" {
  cidr_block = "10.0.0.0/16"
    enable_dns_support   = true
  enable_dns_hostnames = true
}


# Create Public Subnets across AZs
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.cloudhight_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-2a"  
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.cloudhight_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "eu-west-2b"  
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet3" {
  vpc_id                  = aws_vpc.cloudhight_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "eu-west-2c"  
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cloudhight_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-west-2a"  
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.cloudhight_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2b"  
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet3" {
  vpc_id                  = aws_vpc.cloudhight_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-2c"  
  map_public_ip_on_launch = true
}

# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cloudhight_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloudhight_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}  

resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
  
}

# Create an application load balancer
resource "aws_lb" "cloudhight_lb" {
  name               = "cloudhight-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet2.id]
}

resource "aws_iam_role" "example_role" {
  name = "Jenkins-terraform"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.example_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "example_profile" {
  name = "Jenkins-terraform"
  role = aws_iam_role.example_role.name
}


