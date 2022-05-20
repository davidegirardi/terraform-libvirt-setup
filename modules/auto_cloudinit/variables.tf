variable "project_name" {
  description = "Commont prefix used by all the VMs"
  type        = string
}

variable "project_pool_name" {
  description = "Name of the pool to use to create the disks"
  type        = string
}

variable "project_machines" {
  description = "Map of project names to configuration."
  type        = map(any)
}

variable "os_image_catalog" {
  description = "Map operating systems to base disk images"
  type        = map(any)
}

variable "ssh_pubkey" {
  description = "File with the SSH public key to install in the machines"
  type        = string
}
