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
    name = "${var.project_name}"
    type = "dir"
    path = "${var.pool_prefix}/${var.project_name}"
}

##################################################
#                                                #
#    Create dedicated network for the project    #
#                                                #
##################################################
resource "libvirt_network" "project_network" {
    name = "${var.project_name}.${var.network_tld}"
    domain = "${var.project_name}.${var.network_tld}"
    addresses = var.cidr_networks
    autostart = true
    dns {
        local_only = true
    }
    # Configure name resolution in Network Manager, REQUIRES SUDO!
    provisioner "local-exec" {
         command = <<-EOC
             echo "server=/${self.domain}/${var.dnsmasq_listen}" | sudo tee -a /etc/NetworkManager/dnsmasq.d/libvirtd_dnsmasq.conf
             sudo systemctl reload NetworkManager.service
         EOC
    }
    # Remove name resolution from Network Manager on destroy, REQUIRES SUDO!
    provisioner "local-exec" {
         when = destroy
         command = <<-EOC
             sudo sed -i '\/server=\/${self.domain}\/.*$/d' /etc/NetworkManager/dnsmasq.d/libvirtd_dnsmasq.conf
             sudo systemctl reload NetworkManager.service
         EOC
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
    templates_path = var.templates_path
    ansible_playbooks = var.ansible_playbooks
    os_image_catalog = var.os_image_catalog
    # From variables.tf
    project_name = var.project_name
    project_machines = var.project_machines
    project_pool_name = libvirt_pool.project_pool.name
}

####################################
#                                  #
#    Create volumes for the VMs    #
#                                  #
####################################
resource "libvirt_volume" "cow_volume" {
    for_each = var.project_machines
    name   = "${each.key}.${libvirt_network.project_network.domain}.qcow2"
    # Use the base volume created above
    base_volume_id = module.auto_base_volume.volumes["${each.value.distro}"].id
    base_volume_pool = libvirt_pool.project_pool.name
    pool = libvirt_pool.project_pool.name
}

#############################
#                           #
#    Create the machines    #
#                           #
#############################
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
    # Shared folders
    dynamic "filesystem" {
        for_each = each.value.filesystems
        content {
            source = filesystem.value["source"]
            target = filesystem.key
            readonly = filesystem.value["readonly"]
        }
    }
    # Deployment playbook: name the machine and do other stuff
    # See: ansible/linux_deploy.yml and ansible/windows_deploy.yml
    provisioner "local-exec" {
         command = <<-EOC
             ansible-playbook -u ${var.os_image_catalog["${each.value.distro}"].ansible_user} -i %{ if replace(self.network_interface[0].addresses[0], ":", "") == self.network_interface[0].addresses[0] }${self.network_interface[0].addresses[0]}%{ else }${self.network_interface[0].addresses[1]}%{ endif}, -e newhostname=${self.name} ${var.ansible_playbooks}/${var.os_image_catalog[each.value.distro].provision_playbook}
         EOC
    }
}
