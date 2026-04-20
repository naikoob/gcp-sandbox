# GCS Bucket
resource "google_storage_bucket" "app_bucket" {
  name                        = var.bucket_name
  location                    = var.region
  project                     = var.project_id
  uniform_bucket_level_access = true
  force_destroy               = true # For demo/dev purposes
}

# Service Account for Cloud Run
resource "google_service_account" "run_sa" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name}"
  project      = var.project_id
}

# IAM: Storage access
resource "google_storage_bucket_iam_member" "bucket_user" {
  bucket = google_storage_bucket.app_bucket.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.run_sa.email}"
}

# IAM: Cloud SQL Client
resource "google_project_iam_member" "sql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

# Cloud Run Service (v2)
resource "google_cloud_run_v2_service" "app_service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.run_sa.email

    containers {
      image = var.image

      env {
        name  = "DB_HOST"
        value = var.db_instance_ip
      }
      env {
        name  = "DB_NAME"
        value = var.db_name
      }
      env {
        name  = "DB_USER"
        value = var.db_user
      }
      env {
        name  = "DB_PASS"
        value = var.db_password
      }
      env {
        name  = "BUCKET_NAME"
        value = google_storage_bucket.app_bucket.name
      }
    }

    vpc_access {
      network_interfaces {
        network    = var.network_id
        subnetwork = var.subnet_id
      }
      egress = "ALL_TRAFFIC"
    }
  }

  ingress = "INGRESS_TRAFFIC_INTERNAL_ONLY"
}

# Allow unauthenticated access (Optional/For demo)
# resource "google_cloud_run_v2_service_iam_member" "public_access" {
#   name     = google_cloud_run_v2_service.app_service.name
#   location = google_cloud_run_v2_service.app_service.location
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }
