# Project configuration

variable "project_name" {
  description = "Common prefix used by all the VMs"
  type        = string
  default     = "testproj"
}

variable "cidr_networks" {
  description = "Network ranges (IPv4 and IPv6) in CIDR format"
  type        = list(any)
  default     = ["10.11.12.0/24"]
}

variable "project_machines" {
  description = "Map of project names to configuration."
  type        = map(any)
  default = {

    lnx1 = {
      memory     = 1024,
      vcpu       = 1,
      distro     = "debian_cloud"
      qemu_agent = false
      disk_size  = 20,
      filesystems = {
        main = {
          source   = "/tmp",
          readonly = true
        }
      }
    }

    lnx2 = {
      memory     = 1024,
      vcpu       = 1,
      distro     = "debian_cloud"
      qemu_agent = false,
      disk_size  = 20,
      filesystems = {
      }
    }

    lnx3 = {
      memory     = 1024,
      vcpu       = 1,
      distro     = "arch_cloud"
      qemu_agent = false
      disk_size  = 20,
      filesystems = {
      }
    }

  }
}

variable "ssh_pubkey_file" {
  description = "File with the SSH public key to install in the machines"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
