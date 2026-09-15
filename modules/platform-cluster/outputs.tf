# Desired boot-disk images, exposed so scripts/tf_apply.sh can read the intended
# image from Terraform itself (via `terraform console`) rather than parsing
# config text. Used to detect which VMs still need a rolling -replace.
output "platform_disk_image" {
  description = "Desired boot-disk image for the standalone platform VMs."
  value       = var.instances.attributes.disk_image
}

output "api_disk_image" {
  description = "Desired boot-disk image for the API cluster instances."
  value       = var.api_instances.machine_attributes.disk_image
}
