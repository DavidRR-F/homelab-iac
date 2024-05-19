packer {
  required_plugins {
    name = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "admin_temp_password" {
  type    = string
  default = ""
}

variable "ansible_ssh_public_key" {
  type    = string
  default = ""
}

variable "proxmox_api_url" {
  type    = string 
}

variable "proxmox_api_token_id" {
  type    = string
}

variable "proxmox_api_token_secret" {
  type    = string 
  sensitive = true
}

source "proxmox-iso" "ubuntu2404server" {
  
  proxmox_url = "${var.proxmox_api_url}"
  username = "${var.proxmox_api_token_id}"
  token = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  node = "proxmox"
  vm_id = "300"
  vm_name = "ubuntu2404server"
  template_description = "Base Ubuntu Server Template"

  iso_file = "local:iso/ubuntu-24.04-live-server-amd64.iso"
  iso_storage_pool = "local"
  unmount_iso = true

  qemu_agent = true 

  scsi_controller = "virtio-scsi-pci"

  disks {
    disk_size = "20G"
    format = "qcow2"
    storage_pool = "local-lvm"
    type = "virtio"
  }

  cores = "1"
  memory = "2028"

  network_adapters {
    model = "virtio"
    bridge = "vmbr0"
    firewall = "false"
  }

  cloud_init = true
  cloud_init_storage_pool = "local-lvm"

  boot_command = [
    "<esc><wait><esc><wait>",
    "<f6><wait><esc><wait>",
    "<bs><bs><bs><bs><bs>",
    "autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "--- <enter>"
  ]
  boot = "c"
  boot_wait = "10s"

  http_directory = "http"

  http_bind_address = "0.0.0.0"
  http_port_min = 8802
  http_port_max = 8802

  ssh_username = "admin"
  ssh_password = "${var.admin_temp_password}"
  ssh_timeout  = "20m"

}

build {
  name = "ubuntu2404server"
  sources = [
    "source.proxmox-iso.ubuntu2404server"
  ]
  
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud init...'",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine_id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }

  provisioner "file" {
    source = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.s/99-pve.cfg"]
  }
  
}
