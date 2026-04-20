# Private IP Allocation for PSA
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "${var.instance_name}-psa-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
  project       = var.project_id
}

# Service Networking Connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

# Random Suffix for unique instance name
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# Cloud SQL Instance
resource "google_sql_database_instance" "instance" {
  name                = "${var.instance_name}-${random_id.db_name_suffix.hex}"
  project             = var.project_id
  region              = var.region
  database_version    = "POSTGRES_18"
  encryption_key_name = var.kms_key_id

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier    = var.tier
    edition = var.edition
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_id
    }

    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
    }
  }

  lifecycle {
    ignore_changes = [settings[0].disk_size]
  }
}

# Default Database
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
  project  = var.project_id
}

# Application User
resource "random_password" "user_password" {
  length  = 16
  special = true
}

resource "google_sql_user" "app_user" {
  name     = "app_user"
  instance = google_sql_database_instance.instance.name
  password = random_password.user_password.result
  project  = var.project_id
}
