terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

##############################################
#                                            #
#    Create storage pool for the project     #
#                                            #
##############################################
resource "libvirt_pool" "project_pool" {
  name = var.project_name
  type = "dir"
  target {
    path = "${var.pool_prefix}/${var.project_name}"
  }
}

##################################################
#                                                #
#    Create dedicated network for the project    #
#                                                #
##################################################
resource "libvirt_network" "project_network" {
  name      = "${var.project_name}.${var.network_tld}"
  domain    = "${var.project_name}.${var.network_tld}"
  addresses = var.cidr_networks
  autostart = true
  dns {
    enabled    = true
    local_only = true
  }
}

#############################################################
#                                                           #
#    Create base volumes shared by the Operating Systems    #
#                                                           #
#############################################################
module "auto_base_volume" {
  source = "./modules/auto_base_volume"
  # From global_config.tf
  templates_path    = var.templates_path
  ansible_playbooks = var.ansible_playbooks
  os_image_catalog  = var.os_image_catalog
  # From variables.tf
  project_name      = var.project_name
  project_machines  = var.project_machines
  project_pool_name = libvirt_pool.project_pool.name
}

####################################
#                                  #
#    Create volumes for the VMs    #
#                                  #
####################################
resource "libvirt_volume" "cow_volume" {
  for_each = var.project_machines
  name     = "${each.key}.${libvirt_network.project_network.domain}.qcow2"
  # Use the base volume created above
  base_volume_id   = module.auto_base_volume.volumes["${each.value.distro}"].id
  base_volume_pool = libvirt_pool.project_pool.name
  pool             = libvirt_pool.project_pool.name
  size             = each.value.disk_size * 1024 * 1024 * 1024
}

##################################
#                                #
#    Create cloudinit volumes    #
#                                #
##################################
module "auto_cloudinit" {
  source = "./modules/auto_cloudinit/"
  # From global_config.tf
  os_image_catalog = var.os_image_catalog
  # From variables.tf
  project_name      = var.project_name
  project_machines  = var.project_machines
  project_pool_name = libvirt_pool.project_pool.name
  ssh_pubkey        = var.ssh_pubkey_file
}

#############################
#                           #
#    Create the machines    #
#                           #
#############################
resource "libvirt_domain" "domain" {
  for_each   = var.project_machines
  name       = "${each.key}.${libvirt_network.project_network.domain}"
  memory     = each.value.memory
  vcpu       = each.value.vcpu
  qemu_agent = each.value.qemu_agent
  cloudinit  = var.os_image_catalog["${each.value.distro}"].cloudinit_template != "" ? module.auto_cloudinit.cloudinit_disks["${each.key}"].id : null

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.cow_volume[each.key].id
  }

  network_interface {
    network_id     = libvirt_network.project_network.id
    wait_for_lease = true
  }

  video {
    type = var.os_image_catalog["${each.value.distro}"].video_type
  }

  xml {
    # A serial port is neede by Debian for resizing the disk via cloud-init
    xslt = file("xslt/add_spice_and_serial.xsl")
  }

  # Shared folders
  dynamic "filesystem" {
    for_each = each.value.filesystems
    content {
      source   = filesystem.value["source"]
      target   = filesystem.key
      readonly = filesystem.value["readonly"]
    }
  }

  # Deployment playbook: name the machine and do other stuff
  # See ansible/windows_deploy.yml
  # It can be empty for machines deployed via cloud init
  provisioner "local-exec" {
    command = <<-EOC
          ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
            -u ${var.os_image_catalog["${each.value.distro}"].ansible_user} \
            -i ${self.name}, \
            -e newhostname=${self.name} ${var.ansible_playbooks}/${var.os_image_catalog[each.value.distro].provision_playbook} \
          || echo "No ansible playbook supplied :)"
         EOC
  }

  # Remove the ssh fingerprint from known_hosts
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOC
              until ssh-keygen -R ${self.name}; do sleep 1; done
         EOC
  }

  timeouts {
    create = "3m"
  }

}
