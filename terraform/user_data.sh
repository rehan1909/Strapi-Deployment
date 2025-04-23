#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Authenticate with ECR
$(aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${repo_url})

# Run Docker container from ECR
docker pull ${repo_url}:${image_tag}
docker run -d -p 80:1337 ${repo_url}:${image_tag}