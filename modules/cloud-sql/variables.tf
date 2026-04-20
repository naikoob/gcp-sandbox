variable "project_id" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "region" {
  description = "The region for the SQL instance"
  type        = string
}

variable "network_id" {
  description = "The ID of the VPC network"
  type        = string
}

variable "instance_name" {
  description = "The name of the SQL instance"
  type        = string
}

variable "db_name" {
  description = "The name of the default database"
  type        = string
  default     = "app_db"
}

variable "tier" {
  description = "The machine tier for the SQL instance"
  type        = string
  default     = "db-f1-micro"
}

variable "edition" {
  description = "The edition of the SQL instance (ENTERPRISE or ENTERPRISE_PLUS)"
  type        = string
  default     = "ENTERPRISE"
}

variable "kms_key_id" {
  description = "The ID of the KMS Crypto Key for encryption"
  type        = string
}
