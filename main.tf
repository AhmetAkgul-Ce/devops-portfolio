terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1" # Stockholm bölgesi (Ekran görüntüne göre)
}
# En güncel Ubuntu 22.04 imajını otomatik bul
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (Ubuntu'nun resmi sahipleri)
}
# --- 1. ANAHTAR YÖNETİMİ (Otomatik Oluşturma) ---
resource "tls_private_key" "ed25519" {
  algorithm = "ED25519"
}

# Private key'i yerel klasöre kaydet
resource "local_file" "private_key" {
  content         = tls_private_key.ed25519.private_key_pem
  filename        = "${path.module}/devops-key.pem"
  file_permission = "0400"
}

# Public key'i AWS'e yükle
resource "aws_key_pair" "deployer" {
  key_name   = "devops-portfolio-key"
  public_key = tls_private_key.ed25519.public_key_openssh
}

# --- 2. AĞ ALTYAPISI (VPC, Subnet, Gateway) ---
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devops-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "devops-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# --- 3. GÜVENLİK GRUBU (SSH + HTTP) ---
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  # SSH (22) - Uzaktan yönetim için
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP (80) - Web uygulaması erişimi için (Plan Adım 5 için şart)
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tüm giden trafiğe izin ver
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

# --- 4. EC2 INSTANCE ---
resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id  # Bunu yapıştır
  instance_type          = "t3.micro"              # Free Tier uygun
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "devops-web-server"
  }
}

# --- 5. ÇIKTILAR (IP Adresini Göster) ---
output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "EC2 instance'ının public IPv4 adresi"
}

output "ssh_command" {
  value       = "ssh -i ./devops-key.pem ubuntu@${aws_instance.web.public_ip}"
  description = "SSH ile bağlanmak için kullanacağın komut"
}