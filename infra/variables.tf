variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "my-react-node-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "bucket_name" {
  description = "S3 bucket name for frontend"
  type        = string
}

#variable "container_image" {
#description = "ECR container image URL for backend"
#type        = string
#}

variable "app_port" {
  description = "Backend container port"
  type        = number
  default     = 5000
}

variable "backend_desired_count" {
  description = "Number of backend ECS tasks"
  type        = number
  default     = 2
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
}