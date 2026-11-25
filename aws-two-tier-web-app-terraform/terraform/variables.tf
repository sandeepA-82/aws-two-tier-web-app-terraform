variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used for resource names and tags."
  type        = string
  default     = "two-tier-app"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "admin_cidr" {
  description = "Your public IPv4 address in CIDR notation, e.g. 203.0.113.10/32."
  type        = string
  validation {
    condition     = can(cidrnetmask(var.admin_cidr))
    error_message = "admin_cidr must be a valid IPv4 CIDR block."
  }
}

variable "db_username" {
  description = "Master username for the RDS database."
  type        = string
  default     = "appadmin"
}

variable "db_password" {
  description = "Master password for the RDS database. Supply via TF_VAR_db_password."
  type        = string
  sensitive   = true
}
