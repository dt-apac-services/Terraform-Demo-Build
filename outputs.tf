output "vm_public_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
}

output "vm_gcloud_ssh_command" {
  value = "gcloud compute ssh --zone '${google_compute_instance.vm_instance.zone}' '${google_compute_instance.vm_instance.name}' --project '${google_compute_instance.vm_instance.project}'"
}