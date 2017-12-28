variable "network_region" {
  type        = "string"
  description = "The region to use"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC id"
}

variable "subnet_id" {
  type        = "string"
  description = "The subnet id (single)"
}
