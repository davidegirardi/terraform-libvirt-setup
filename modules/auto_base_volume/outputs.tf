output "volumes" {
    description = "Base volume for consolidation of the distros (OSs) running in the project"
    value = libvirt_volume.base_volume
}
