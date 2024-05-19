# Homelab ISO Image Pipeline


![image](https://github.com/DavidRR-F/homelab-iac/assets/99210748/28c0e373-1c2b-4d01-bd74-21e5b77950db)

## Install Packer
```bash 
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt-get update && sudo apt-get install packer
$ sudo apt-get install qemu-kvm qemu
```
