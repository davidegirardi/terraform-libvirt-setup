# Global environment configuration

# Set by the TF_VAR_packer_templates_path environment variable
variable "packer_templates_path" {
    description = "Path to the template disks built by packer, uses the TF_VAR_packer_templates_path environment variable"
}

# Map different OSs to file in the packer_templates_path set above
variable "os_image_catalog" {
    description = "Map operating systems to base disk images"
    type = map
    default = {
        "arch" = {
            disk = "arch-2021.06.01-x86_64.qcow2",
            provision_playbook = "rename.yml"
            ansible_user = "user"
        },
        "debian10" = {
            disk = "debian10-10.10.0-amd64.qcow2",
            provision_playbook = "rename.yml"
            ansible_user = "user"
        },
        "windows10" = {
            disk = "windows10-20H2_v2-x86_64.qcow2",
            provision_playbook = "windows_rename.yml"
            ansible_user = "administrator"
        }
    }
}

# Set by the TF_VAR_ansible_playbooks environment variable
variable "ansible_playbooks" {
    description = "Path to the ansible playbook directory. Uses the TF_VAR_ansible_playbooks environment variable"
}

variable "network_tld" {
    description = "Network TLD"
    type = string
    default = "vms"
}

