terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

locals {
  # Loop through the distros in the project and create a base_volume name
  required_base_volumes = {
    for machine in var.project_machines :
    machine.distro => {
      base_name = "${var.project_name}_${machine.distro}_base-volume.qcow2"
      source    = substr("${var.os_image_catalog[machine.distro].disk}", 0, 8) == "https://" ? "${var.os_image_catalog[machine.distro].disk}" : "${var.templates_path}/${var.os_image_catalog[machine.distro].disk}"
    }...
  }
}

resource "libvirt_volume" "base_volume" {
  # Since multiple machines could have the same distro, using [0] will take care of that
  for_each = local.required_base_volumes
  name     = each.value[0].base_name
  source   = each.value[0].source
  pool     = var.project_pool_name
  format   = "qcow2"
}

