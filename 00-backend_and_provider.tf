terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend          "s3"             {}
  required_version = ">= 0.11.1"
}

provider "aws" {
  region     = "${var.network_region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  version    = "~> 1.6"
}

variable "access_key" {
  description = "Read at run-time"
  type        = "string"
}

variable "secret_key" {
  description = "Read at run-time"
  type        = "string"
}
