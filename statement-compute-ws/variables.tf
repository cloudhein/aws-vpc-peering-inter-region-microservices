variable "region" {
  description = "AWS Region for the Statement service."
  type        = string
  default     = "ap-northeast-1"
}

variable "certificate_arn" {
  description = "Existing ISSUED ACM certificate in this Region. Internal ALBs must match their service DNS name."
  type        = string
}

variable "ami_id" {
  description = "Optional pinned Ubuntu x86_64 AMI. The image must include curl, ca-certificates, systemd and cloud-init."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Use an x86_64 instance type compatible with the AMD64 artifacts."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Root volume size in GiB. Must be at least 8 GiB for Ubuntu."
  type        = number
  default     = 10
  validation {
    condition     = var.root_volume_size >= 8
    error_message = "Root volume size must be at least 8 GiB."
  }
}

variable "ssh_public_key_secret_id" {
  description = "The AWS Secrets Manager secret ID that contains the SSH public key for the EC2 instance."
  type        = string
  default     = "microservices/ssh-public-key"
}