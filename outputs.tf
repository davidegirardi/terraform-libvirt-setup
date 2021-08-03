output "message" {
    description = "Inform about output files"
    value = "See inventory.json for ansible and ssh_config.conf for ssh"
}

resource "local_file" "ansible_inventory" {
    filename = "inventory.json"
    content = templatefile("file_templates/ansible_inventory.tmpl", {
        generated_machines = libvirt_domain.domain
    })
    file_permission = "0644"
}
resource "local_file" "ssh_config" {
    filename = "ssh_config.conf"
    content = templatefile("file_templates/ssh_config.tmpl", {
        generated_machines = libvirt_domain.domain
    })
    file_permission = "0644"
}
