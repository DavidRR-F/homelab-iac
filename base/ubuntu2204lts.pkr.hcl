packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

variable "temp_password" {
  type    = string
  default = ""
}

variable "iso_checksum" {
  type    = string
  default = ""
}

variable "key_file" {
  type    = string 
  default = ""
}

source "qemu" "ubuntu" {
  iso_url               = "http://releases.ubuntu.com/22.04/ubuntu-22.04.4-live-server-amd64.iso"
  iso_checksum          = var.iso_checksum
  iso_checksum_type     = "sha256"
  iso_download_timeout  = "60m"
  ssh_username          = "admin"
  ssh_password          = var.temp_password
  ssh_timeout           = "30m"
  shutdown_command      = "echo '${var.temp_password}' | sudo -S shutdown -P now"
}

build {
  sources = [
    "source.qemu.ubuntu"
  ]

  provisioner "file" {
    source      = var.key_file
    destination = "/tmp/ansible.pub"
  }

  provisioner "shell" {
    inline = [
      "sudo useradd -m -s /bin/bash ansible",
      "sudo mkdir /home/ansible/.ssh",
      "sudo mv /tmp/ansible.pub /home/ansible/.ssh/authorized_keys",
      "sudo chown -R ansible:ansible /home/ansible/.ssh",
      "sudo chmod 700 /home/ansible/.ssh",
      "sudo chmod 600 /home/ansible/.ssh/authorized_keys",
      "sudo useradd -m -s /bin/bash admin",
      "echo 'ansible ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/ansible",
      "sudo apt-get install qemu-utils -y"
    ]
  }
}
