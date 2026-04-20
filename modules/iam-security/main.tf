# Enable required APIs
locals {
  services = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "cloudkms.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "run.googleapis.com",
    "storage.googleapis.com"
  ]
}

resource "google_project_service" "services" {
  for_each = toset(local.services)
  project  = var.project_id
  service  = each.value

  disable_on_destroy = false
}

# Application Service Account
resource "google_service_account" "app_sa" {
  account_id   = var.service_account_id
  display_name = "Application Service Account for ${var.service_account_id}"
  project      = var.project_id
}

# IAM Roles for Service Account
resource "google_project_iam_member" "logging_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_project_iam_member" "monitoring_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

# Cloud KMS
resource "google_kms_key_ring" "keyring" {
  name     = var.key_ring_name
  location = var.region
  project  = var.project_id

  depends_on = [google_project_service.services["cloudkms.googleapis.com"]]
}

# Cloud SQL Service Identity (Required for CMEK)
resource "google_project_service_identity" "sql_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "sqladmin.googleapis.com"
}

resource "google_kms_crypto_key" "key" {
  name     = var.crypto_key_name
  key_ring = google_kms_key_ring.keyring.id
  purpose  = "ENCRYPT_DECRYPT"

  lifecycle {
    prevent_destroy = false
  }
}

# Grant KMS permission to Cloud SQL Service Identity
resource "google_kms_crypto_key_iam_member" "sql_kms_user" {
  crypto_key_id = google_kms_crypto_key.key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.sql_sa.email}"
}

