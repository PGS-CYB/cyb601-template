# Upload cloud-init as a Proxmox snippet (enable the "snippets" content
# type on the local datastore first).
resource "proxmox_virtual_environment_file" "cloud_init" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node
  source_raw {
    data      = templatefile("${path.module}/cloud-init.yaml.tftpl", { k3s_version = var.k3s_version })
    file_name = "${var.name}-cloud-init.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "lab" {
  name      = var.name
  node_name = var.node
  pool_id   = var.pool

  clone { vm_id = var.template_id }   # the course Ubuntu 24.04 template

  cpu    { cores = var.cores }
  memory { dedicated = var.memory_mb }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = var.disk_gb
  }

  network_device { bridge = var.bridge }
  agent          { enabled = true }

  initialization {
    datastore_id      = "local-lvm"
    user_data_file_id = proxmox_virtual_environment_file.cloud_init.id
    ip_config { ipv4 { address = "dhcp" } }
    user_account {
      username = "ubuntu"
      keys     = [trimspace(var.ssh_public_key)]
    }
  }
}

output "vm_ip" {
  # requires the guest agent; [1][0] is the first real NIC's address
  value = proxmox_virtual_environment_vm.lab.ipv4_addresses[1][0]
}