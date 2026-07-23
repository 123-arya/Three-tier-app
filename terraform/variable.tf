variable "aws_region" {
  description = "AWS region for EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  type        = string
  default     = "skillpulse"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "total_azs" {
  type        = number
  default     = 2
}

variable "private_subnet" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet" {
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "cluster_version" {
  type        = number
  default     = "1.33"
}

variable "node_instance_type" {
  type        = string
  default     = "t3.medium"  
}

variable "node_desired_count" {
  type        = number
  default     = 2  
}

variable "node_max_count" {
  type        = number
  default     = 4  
}