# Global environment configuration

# Path on the local filesystem for your template qcow2 disks (read only)
# Set by the TF_VAR_templates_path environment variable
variable "templates_path" {
    description = "Path to the template disks built by packer, uses the TF_VAR_templates_path environment variable"
}

# Map different Operating Systems to files in the templates_path set above
# The provision_playbook is an ansible playbook to do basic setup
variable "os_image_catalog" {
    description = "Map operating systems to base disk images"
    type = map
    default = {
        "arch" = {
            disk = "arch-2021.08.01-x86_64.qcow2",
            provision_playbook = "linux_deploy.yml"
            ansible_user = "user"
        },
        "debian10" = {
            disk = "debian10-10.10.0-amd64.qcow2",
            provision_playbook = "linux_deploy.yml"
            ansible_user = "user"
        },
        "debian11" = {
            disk = "debian-11.0.0-amd64.qcow2",
            provision_playbook = "linux_deploy.yml"
            ansible_user = "user"
        },
        "windows10" = {
            disk = "windows10-20H2_v2-x86_64.qcow2",
            provision_playbook = "windows_deploy.yml"
            ansible_user = "administrator"
        }
    }
}

# Where are the provisioning playbooks?
# Set by the TF_VAR_ansible_playbooks environment variable if you want to manage
# this centrally and not use the default ./ansible/ path
variable "ansible_playbooks" {
description = "Path to the ansible playbook directory. Uses the TF_VAR_ansible_playbooks environment variable if set. Defaults to ./ansible/"
    default = "./ansible"
}

# Top level domain for the networks, all the machine will have a name like:
# vmname.projectname.tld
variable "network_tld" {
    description = "Network TLD"
    type = string
    default = "vms"
}

