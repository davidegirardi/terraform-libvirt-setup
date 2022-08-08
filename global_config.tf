# Global environment configuration

# Path on the local filesystem for your template qcow2 disks (read only)
# Set by the TF_VAR_templates_path environment variable
variable "templates_path" {
  description = "Path to the template disks built by packer, uses the TF_VAR_templates_path environment variable"
}

variable "pool_prefix" {
  description = "Path to the directory where to create the project pools, uses the TF_VAR_pool_prefix environment variable"
}

# Map different Operating Systems to files in the templates_path set above
# The provision_playbook is an ansible playbook to do basic setup
variable "os_image_catalog" {
  description = "Map operating systems to base disk images"
  type        = map(any)
  default = {

    "arch_cloud" = {
      disk               = "https://ftp.acc.umu.se/mirror/archlinux/images/latest/Arch-Linux-x86_64-cloudimg.qcow2"
      provision_playbook = ""
      ansible_user       = "arch"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "arch_cloud_cache" = {
      disk               = "Arch-Linux-x86_64-cloudimg.qcow2"
      provision_playbook = ""
      ansible_user       = "arch"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "arch_custom" = {
      disk               = "arch-2022.08.05-x86_64.qcow2"
      provision_playbook = "linux_deploy.yml"
      ansible_user       = "user"
      video_type         = "virtio"
      cloudinit_template = ""
    },

    "debian10_cloud" = {
      disk               = "https://cloud.debian.org/images/cloud/buster/daily/latest/debian-10-generic-amd64-daily.qcow2",
      provision_playbook = ""
      ansible_user       = "debian"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "debian10_cloud_cache" = {
      disk               = "debian-10-generic-amd64-daily.qcow2",
      provision_playbook = ""
      ansible_user       = "debian"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "debian10_custom" = {
      disk               = "debian-10.11.0-amd64.qcow2",
      provision_playbook = "linux_deploy.yml"
      ansible_user       = "user"
      video_type         = "virtio"
      cloudinit_template = ""
    },

    "debian11_cloud" = {
      disk               = "https://cloud.debian.org/images/cloud/bullseye/daily/latest/debian-11-generic-amd64-daily.qcow2",
      provision_playbook = ""
      ansible_user       = "debian"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "debian11_cloud_cache" = {
      disk               = "debian-11-generic-amd64-daily.qcow2",
      provision_playbook = ""
      ansible_user       = "debian"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "debian11_custom" = {
      disk               = "debian-11.4.0-amd64.qcow2",
      provision_playbook = "linux_deploy.yml"
      ansible_user       = "user"
      video_type         = "virtio"
      cloudinit_template = ""
    },

    "ubuntu1604_server_cloud" = {
      disk               = "https://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img",
      provision_playbook = ""
      ansible_user       = "ubuntu"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "ubuntu_server_cloud" = {
      disk               = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64-disk-kvm.img",
      provision_playbook = ""
      ansible_user       = "ubuntu"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "ubuntu_server_cloud_cache" = {
      disk               = "jammy-server-cloudimg-amd64-disk-kvm.img",
      provision_playbook = ""
      ansible_user       = "ubuntu"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "windows10" = {
      disk               = "windows10-21H2-x86_64.qcow2",
      provision_playbook = "windows_deploy.yml"
      ansible_user       = "administrator"
      video_type         = "qxl"
      cloudinit_template = ""
    }

    "windows11" = {
      disk               = "windows11-v1-x86_64.qcow2",
      provision_playbook = "windows_deploy.yml"
      ansible_user       = "administrator"
      video_type         = "qxl"
      cloudinit_template = ""
    }

  }
}

# Where are the provisioning playbooks?
# Set by the TF_VAR_ansible_playbooks environment variable if you want to manage
# this centrally and not use the default ./ansible/ path
variable "ansible_playbooks" {
  description = "Path to the ansible playbook directory. Uses the TF_VAR_ansible_playbooks environment variable if set. Defaults to ./ansible/"
  default     = "./ansible"
}

# Top level domain for the networks, all the machine will have a name like:
# vmname.projectname.tld
variable "network_tld" {
  description = "Network TLD"
  type        = string
  default     = "vms"
}

