variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "key"
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}

variable "repo_url" {
  description = "ECR repository URL"
  type        = string
}
