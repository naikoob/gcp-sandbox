output "service_account_email" {
  value = google_service_account.app_sa.email
}

output "key_ring_id" {
  value = google_kms_key_ring.keyring.id
}

output "crypto_key_id" {
  value = google_kms_crypto_key.key.id
}
