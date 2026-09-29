variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_public_key" {
  description = "SSH public key for the EC2 key pair"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo to clone (e.g. talhajubayerrbai/tic-tac-toe)"
  type        = string
  default     = "talhajubayerrbai/tic-tac-toe"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 3000
}
