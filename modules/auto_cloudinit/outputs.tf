output "cloudinit_disks" {
  description = "Shared cloudinit disks"
  value       = libvirt_cloudinit_disk.disk
}
