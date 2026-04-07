terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# 1. Ağ Yapısı (VPC + IGW + Subnet + Route Table)
resource "aws_vpc" "lite_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "lite_igw" {
  vpc_id = aws_vpc.lite_vpc.id
}

resource "aws_subnet" "lite_subnet" {
  vpc_id                  = aws_vpc.lite_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "lite_rt" {
  vpc_id = aws_vpc.lite_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lite_igw.id
  }
}

resource "aws_route_table_association" "lite_rta" {
  subnet_id      = aws_subnet.lite_subnet.id
  route_table_id = aws_route_table.lite_rt.id
}

# 2. Güvenlik Grubu
resource "aws_security_group" "lite_sg" {
  name        = "lite-ssh-only"
  description = "Lite mode security group"
  vpc_id      = aws_vpc.lite_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Ubuntu Sunucu
resource "aws_instance" "lite_server" {
  ami                    = "ami-0281b0943230d40d1"
  instance_type          = "t3.micro"
  key_name               = "lite-key"
  subnet_id              = aws_subnet.lite_subnet.id
  vpc_security_group_ids = [aws_security_group.lite_sg.id]

  tags = { Name = "Lite-Server" }
}

output "server_ip" {
  value = aws_instance.lite_server.public_ip
}