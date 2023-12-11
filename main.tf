terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  cloud {
    organization = "ITTalent-Hackathon-ii-GabrielGabriel"

    workspaces {
      name = "terraform-github-actions-devops-hackathon"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "instance_sg" {
  name = "grupo-de-seguranca-ittalent-hackathon-ii"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = "ami-0fc5d935ebf8bc3bc"
  instance_type               = "t2.nano"
  key_name                    = "hackathon-ii-ittalent"
  associate_public_ip_address = true

  tags = {
    Name = "ITTalent-Hackathon-II"
  }

  timeouts {
    create = "60m"
  }

  user_data = file("${path.module}/user-data-nginx.sh")
}

output "ec2_public_ips" {
  value = {
    public_ip  = aws_instance.ec2_instance.public_ip
    public_dns = aws_instance.ec2_instance.public_dns
  }
}
