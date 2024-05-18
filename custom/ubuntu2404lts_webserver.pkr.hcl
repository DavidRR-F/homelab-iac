variable "base_image" {
  type    = string
  default = "output/ubuntu-base.box"
}

variable "temp_password" {
  type    = string
  default = ""
}

source "virtualbox" "custom" {
  source_path = var.base_image
  ssh_username = "admin"
  ssh_password = var.temp_password
  shutdown_command = "echo '${var.temp_password}' | sudo -S shutdown -P now"
}

build {
  sources = [
    "source.virtualbox.custom"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }

  post-processor "vagrant" {
    output = "output/ubuntu-custom.box"
  }
}

