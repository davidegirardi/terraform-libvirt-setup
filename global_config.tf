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
      disk               = "arch-2024.03.01-x86_64.qcow2"
      provision_playbook = ""
      ansible_user       = "arch"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "debian_cloud" = {
      disk               = "https://cloud.debian.org/images/cloud/bookworm/daily/latest/debian-12-generic-amd64-daily.qcow2",
      provision_playbook = ""
      ansible_user       = "debian"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "debian_cloud_cache" = {
      disk               = "debian-12-generic-amd64-daily.qcow2",
      provision_playbook = ""
      ansible_user       = "debian"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "debian_custom" = {
      disk               = "debian-12.5.0-amd64.qcow2",
      provision_playbook = ""
      ansible_user       = "debian"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "fedora_cloud" = {
      disk               = "https://download.fedoraproject.org/pub/fedora/linux/releases/38/Cloud/x86_64/images/Fedora-Cloud-Base-38-1.6.x86_64.qcow2",
      provision_playbook = ""
      ansible_user       = "fedora"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "fedora_cloud_cache" = {
      disk               = "Fedora-Cloud-Base-38-1.6.x86_64.qcow2",
      provision_playbook = ""
      ansible_user       = "fedora"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "ubuntu_server_cloud" = {
      disk               = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img",
      provision_playbook = ""
      ansible_user       = "ubuntu"
      video_type         = "virtio"
      cloudinit_template = "templates/cloud_init.cfg"
    },

    "ubuntu_server_cloud_cache" = {
      disk               = "noble-server-cloudimg-amd64.img",
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

