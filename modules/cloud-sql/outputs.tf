output "instance_name" {
  value = google_sql_database_instance.instance.name
}

output "instance_private_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "db_user_password" {
  value     = random_password.user_password.result
  sensitive = true
}
