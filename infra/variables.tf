variable "name"           { type = string }  # lab-LASTNAME
variable "node"           { type = string }  # the Proxmox node name
variable "template_id"    { type = number }  # the course template's VM ID
variable "pool"           { type = string }  # your resource pool
variable "ssh_public_key" { type = string }  # your public key, from Week 0
variable "k3s_version"    { type = string }  # pinned by your instructor

variable "bridge"    { type = string, default = "vmbr1" }
variable "cores"     { type = number, default = 2 }
variable "memory_mb" { type = number, default = 6144 }
variable "disk_gb"   { type = number, default = 50 }