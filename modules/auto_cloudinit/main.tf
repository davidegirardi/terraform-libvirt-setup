terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

resource "libvirt_cloudinit_disk" "disk" {
  for_each = {
    for machinename, machine in var.project_machines : machinename => machine if var.os_image_catalog[machine.distro].cloudinit_template != ""
  }
  user_data = templatefile("${var.os_image_catalog["${each.value.distro}"].cloudinit_template}", {
    hostname     = "${each.key}",
    ssh_pubkey   = file("${var.ssh_pubkey}"),
    ansible_user = "${var.os_image_catalog["${each.value.distro}"].ansible_user}"
  })
  name = "${var.project_name}_${each.key}_cloudinit.iso"
  pool = var.project_pool_name
}
