provider "aws" {
  region = var.region
}

# Security Group
resource "aws_security_group" "rehanstrapi_sg" {
  name        = "strapi-security-group-2"
  description = "Allow ports 22 and 1337"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Rehan-strapi-sg"
  }
}

data "aws_vpc" "default" {
  default = true
}


resource "aws_instance" "strapi_ec2" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.rehanstrapi_sg.id]


  user_data = templatefile("${path.module}/user_data.sh", {
    image_tag = var.image_tag
    repo_url  = var.repo_url
    region    = var.region
  })

  tags = {
    Name = "Rehan-Strapi-Instance"
  }
}