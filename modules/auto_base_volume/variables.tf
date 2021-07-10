variable "project_name" {
    description = "Commont prefix used by all the VMs"
    type = string
}

variable "project_pool_name" {
    description = "Name of the pool to use to create the disks"
    type = string
}

variable "project_machines" {
    description = "Map of project names to configuration."
    type = map
}

# Set by the TF_VAR_packer_templates_path environment variable
variable "packer_templates_path" {
    description = "Path to the template disks built by packer, uses the TF_VAR_packer_templates_path environment variable"
}

# Set by the TF_VAR_ansible_playbooks environment variable
variable "ansible_playbooks" {
    description = "Path to the ansible playbook directory. Uses the TF_VAR_ansible_playbooks environment variable"
}


variable "os_image_catalog" {
    description = "Map operating systems to base disk images"
    type = map
}

