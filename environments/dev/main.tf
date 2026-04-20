# Environment-specific configuration for Development

variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

variable "region" {
  description = "The default region for resources"
  type        = string
  default     = "asia-southeast1"
}

module "networking" {
  source       = "../../modules/networking"
  project_id   = var.project_id
  region       = var.region
  network_name = "dev-vpc"
  subnets = [
    {
      name = "dev-subnet-01"
      cidr = "10.0.1.0/24"
    }
  ]
}

module "iam_security" {
  source             = "../../modules/iam-security"
  project_id         = var.project_id
  region             = var.region
  service_account_id = "dev-app-sa"
  key_ring_name      = "dev-keyring"
  crypto_key_name    = "dev-app-key"
}

module "cloud_sql" {
  source        = "../../modules/cloud-sql"
  project_id    = var.project_id
  region        = var.region
  network_id    = module.networking.network_id
  instance_name = "dev-postgres"
  db_name       = "dev_app_db"
  kms_key_id    = module.iam_security.crypto_key_id

  depends_on = [module.iam_security]
}

module "cloud_run" {
  source         = "../../modules/cloud-run"
  project_id     = var.project_id
  region         = var.region
  service_name   = "dev-app-service"
  network_id     = module.networking.network_id
  subnet_id      = module.networking.subnet_ids["dev-subnet-01"]
  bucket_name    = "${var.project_id}-dev-app-data"
  db_instance_ip = module.cloud_sql.instance_private_ip
  db_name        = "dev_app_db"
  db_user        = "app_user"
  db_password    = module.cloud_sql.db_user_password

  depends_on = [module.iam_security, module.cloud_sql]
}
