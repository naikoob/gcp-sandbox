variable "project_id" {
  description = "The ID of the project where resources will be created"
  type        = string
}

variable "service_account_id" {
  description = "The ID for the application service account"
  type        = string
}

variable "region" {
  description = "The region for the KMS resources"
  type        = string
}

variable "key_ring_name" {
  description = "The name of the KMS key ring"
  type        = string
}

variable "crypto_key_name" {
  description = "The name of the KMS crypto key"
  type        = string
}
