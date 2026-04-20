variable "project_id" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "region" {
  description = "The primary region for the subnets and NAT"
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name = string
    cidr = string
  }))
}
