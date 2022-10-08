## Requirements
In `/etc/libvirt/qemu.conf`
```
user = "yourusername"
groups = "yourgroup"
```

Set the following environment variables to set:
- The directory containing all of the pools via `TF_VAR_pool_prefix`
- The local path on the filesystem containing the base images via`TF_VAR_templates_path`

## Caching Cloud Images
Head over to `autodownload/` and run `terraform apply` to download today's copy of the cloud images in `TF_VAR_templates_path`.

