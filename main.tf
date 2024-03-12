
# Create a VPC
resource "aws_vpc" "cloudgen_vpc" {
  cidr_block = "10.0.0.0/16"
    enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.cloudgen_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.cloudgen_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet3" {
  vpc_id                  = aws_vpc.cloudgen_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.cloudgen_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1a"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.cloudgen_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1b"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet3" {
  vpc_id                  = aws_vpc.cloudgen_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-1c"  # Replace with your desired availability zone
  map_public_ip_on_launch = true
}
# Create an internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cloudgen_vpc.id
}

# # Attach the internet gateway to the VPC
# resource "aws_internet_gateway_attachment" "attach_gw" {
#   internet_gateway_id = aws_internet_gateway.gw.id
#   vpc_id              = aws_vpc.cloudgen_vpc.id
# }

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloudgen_vpc.id

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


# Create a security group for the load balancer
# # Create a security group for the EC2 instances
resource "aws_security_group" "cloudgen_ec2_sg" {
  vpc_id = aws_vpc.cloudgen_vpc.id
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "TLS from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "ssh from ec2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "web_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "gabekp"

  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.cloudgen_ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex
 
  sudo mkdir actions-runner && cd actions-runner# Download the latest runner package
  sudo curl -o actions-runner-linux-x64-2.314.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-linux-x64-2.314.1.tar.gz# Optional: Validate the hash
  sudo echo "6c726a118bbe02cd32e222f890e1e476567bf299353a96886ba75b423c1137b5  actions-runner-linux-x64-2.314.1.tar.gz" | shasum -a 256 -c# Extract the installer
  sudo tar xzf ./actions-runner-linux-x64-2.314.1.tar.gz
  sudo ./config.sh --url https://github.com/OkiriGabriel/Client-app-devops --token xxxx
  sudo ./svc.sh install
  sudo ./svc.sh start
  sudo apt-get update
  sudo apt-get install nginx
  sudo ufw allow 'Nginx Full'
  sudo systemctl enable nginx
  sudo systemctl start nginx
  sudo systemctl status nginx
  EOF

  tags = {
    "Name" : "Frontend_webserver"
  }
}

resource "aws_instance" "server_app" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = "gabekp"

  subnet_id                   = aws_subnet.public_subnet2.id
  vpc_security_group_ids      = [aws_security_group.cloudgen_ec2_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex
  sudo mkdir actions-runner && cd actions-runner# Download the latest runner package
  sudo curl -o actions-runner-linux-x64-2.314.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.314.1/actions-runner-linux-x64-2.314.1.tar.gz# Optional: Validate the hash
  sudo echo "6c726a118bbe02cd32e222f890e1e476567bf299353a96886ba75b423c1137b5  actions-runner-linux-x64-2.314.1.tar.gz" | shasum -a 256 -c# Extract the installer
  sudo tar xzf ./actions-runner-linux-x64-2.314.1.tar.gz
  sudo ./config.sh --url https://github.com/OkiriGabriel/Client-app-devops --token xxxx
  sudo ./svc.sh install
  sudo ./svc.sh start
  sudo apt-get update
  sudo apt-get install nginx
  sudo ufw allow 'Nginx Full'
  sudo systemctl enable nginx
  sudo systemctl start nginx
  sudo systemctl status nginx
  EOF

  tags = {
    "Name" : "Backend_webserver"
  }
}

# Create a security group for the load balancer
resource "aws_security_group" "lb_sg" {
  vpc_id = aws_vpc.cloudgen_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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

}

# Create an application load balancer
resource "aws_lb" "cloudgen_lb" {
  name               = "cloudgen-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.private_subnet2.id]
}






# Create an RDS instance
resource "aws_db_instance" "cloudgen-rds" {
  identifier              = "cloudgen"
  allocated_storage       = 20

  engine                  = "mysql"          # Replace with your desired database engine
  engine_version       = "5.7"
#   instance_class       = "db.t2.micro"       # Replace with your desired engine version
  instance_class          = var.instance_class   # Replace with your desired instance type
  username                = var.username   # Replace with your desired database username
  password                = var.password   # Replace with your desired database password
  publicly_accessible     = true
  parameter_group_name = "default.mysql5.7"
#   db_subnet_group_name    = aws_db_subnet_group.cloudgen_db_subnet.name
  vpc_security_group_ids  = [aws_security_group.cloudgen_ec2_sg.id]
  skip_final_snapshot     = true
}

# Create a database subnet group
resource "aws_db_subnet_group" "cloudgen_db_subnet" {
  name       = "cloudgen-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.private_subnet2.id]
}
