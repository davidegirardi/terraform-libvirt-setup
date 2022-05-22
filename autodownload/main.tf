terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}

resource "null_resource" "get_images" {
  triggers = {
    always_run = "${timestamp()}"
  }
  for_each = {
    for imagename, imagedata in var.os_image_catalog : imagename => imagedata
    if substr(imagedata.disk, 0, 8) == "https://"
  }
  provisioner "local-exec" {
    command = <<-EOC
      wget --quiet --continue ${each.value.disk}
   EOC
  }
}
