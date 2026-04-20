output "service_url" {
  value = google_cloud_run_v2_service.app_service.uri
}

output "bucket_name" {
  value = google_storage_bucket.app_bucket.name
}
