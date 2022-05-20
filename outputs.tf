resource "local_file" "ansible_inventory" {
  filename = "inventory.json"
  content = templatefile("file_templates/ansible_inventory.tmpl", {
    generated_machines = libvirt_domain.domain
    project_machines   = var.project_machines,
    os_image_catalog   = var.os_image_catalog
  })
  file_permission = "0644"
}

resource "local_file" "ssh_config" {
  filename = "ssh_config.conf"
  content = templatefile("file_templates/ssh_config.tmpl", {
    generated_machines = libvirt_domain.domain,
    project_machines   = var.project_machines,
    os_image_catalog   = var.os_image_catalog
  })
  file_permission = "0644"
}
