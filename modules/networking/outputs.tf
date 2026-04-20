output "network_id" {
  value = google_compute_network.vpc.id
}

output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnet_ids" {
  value = { for k, v in google_compute_subnetwork.subnet : k => v.id }
}
