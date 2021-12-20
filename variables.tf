# Project configuration

variable "project_name" {
    description = "Commont prefix used by all the VMs"
    type = string
    default = "testproj"
}

variable "dnsmasq_listen" {
    description = "dnsmasq binding address"
    type = string
    default = "10.11.12.1"
}

variable "cidr_networks" {
    description = "Network ranges (IPv4 and IPv6) in CIDR format"
    type = list
    default = [ "10.11.12.0/24" ]
}

variable "pool_prefix" {
    description = "Path to the directory where to create the project pools"
    type = string
    default = "/home/vms"
}

variable "project_machines" {
    description = "Map of project names to configuration."
    type = map
    default = {

        lnx1 = {
            memory = 1024,
            vcpu = 1,
            distro = "debian11"
            qemu_agent = false
            filesystems = {
                main = {
                    source = "/tmp",
                    readonly = true
                }
            }
        }

        lnx2 = {
            memory = 1024,
            vcpu = 1,
            distro = "arch"
            qemu_agent = false
            filesystems = {
                main = {
                    source = "/tmp",
                    readonly = true
                }
            }
        }

        win1 = {
            memory = 3024,
            vcpu = 2,
            distro = "windows10"
            qemu_agent = false
            filesystems = {
                main = {
                    source = "/tmp",
                    readonly = true
                }
            }
        }

        win2 = {
            memory = 3024,
            vcpu = 2,
            distro = "windows10"
            qemu_agent = false
            filesystems = {
                main = {
                    source = "/tmp",
                    readonly = true
                }
            }
        }

    }
}
