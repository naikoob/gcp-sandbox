variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

variable "region" {
  description = "The default region for resources"
  type        = string
  default     = "asia-southeast1"
}

variable "zone" {
  description = "The default zone for resources"
  type        = string
  default     = "asia-southeast1-a"
}
