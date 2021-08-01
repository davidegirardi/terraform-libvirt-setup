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

resource "libvirt_network" "project_network" {
    name = "${var.project_name}.${var.network_tld}"
    domain = "${var.project_name}.${var.network_tld}"
    addresses = var.cidr_networks
    autostart = true
    dns {
        local_only = true
    }
   provisioner "local-exec" {
        command = <<-EOC
            echo "server=/${self.domain}/${var.dnsmasq_listen}" | sudo tee -a /etc/NetworkManager/dnsmasq.d/libvirtd_dnsmasq.conf
            sudo systemctl reload NetworkManager.service
        EOC
   }
   provisioner "local-exec" {
        when = destroy
        command = <<-EOC
            sudo sed -i '\/server=\/${self.domain}\/.*$/d' /etc/NetworkManager/dnsmasq.d/libvirtd_dnsmasq.conf
            sudo systemctl reload NetworkManager.service
        EOC
   }
}

resource "libvirt_pool" "project_pool" {
    name = "${var.project_name}"
    type = "dir"
    path = "${var.pool_prefix}/${var.project_name}"
}

module "auto_base_volume" {
    source = "./modules/auto_base_volume"
    # From global_config.tf
    templates_path = var.templates_path
    ansible_playbooks = var.ansible_playbooks
    os_image_catalog = var.os_image_catalog
    # From variables.tf
    project_name = var.project_name
    project_machines = var.project_machines
    project_pool_name = libvirt_pool.project_pool.name
}

resource "libvirt_volume" "cow_volume" {
    for_each = var.project_machines
    name   = "${each.key}.${libvirt_network.project_network.domain}.qcow2"
    base_volume_id = module.auto_base_volume.volumes["${each.value.distro}"].id
    base_volume_pool = libvirt_pool.project_pool.name
    pool = libvirt_pool.project_pool.name
}

resource "libvirt_domain" "domain" {
    for_each = var.project_machines
    name = "${each.key}.${libvirt_network.project_network.domain}"
    memory = each.value.memory
    vcpu = each.value.vcpu
    machine = "q35"
    qemu_agent = each.value.qemu_agent
    cpu = {
        mode = "host-passthrough"
    }
    disk {
        volume_id = libvirt_volume.cow_volume[each.key].id
    }
    network_interface {
        network_id = libvirt_network.project_network.id
        wait_for_lease = true
    }
    video {
        type = "qxl"
    }
    xml {
        xslt = file("add_spice.xsl")
    }
   dynamic "filesystem" {
       for_each = each.value.filesystems
       content {
           source = filesystem.value["source"]
           target = filesystem.key
           readonly = filesystem.value["readonly"]
       }
   }
   provisioner "local-exec" {
        command = <<-EOC
            ansible-playbook -u ${var.os_image_catalog["${each.value.distro}"].ansible_user} -i %{ if replace(self.network_interface[0].addresses[0], ":", "") == self.network_interface[0].addresses[0] }${self.network_interface[0].addresses[0]}%{ else }${self.network_interface[0].addresses[1]}%{ endif}, -e newhostname=${self.name} ${var.ansible_playbooks}/${var.os_image_catalog[each.value.distro].provision_playbook}
        EOC
   }
}
