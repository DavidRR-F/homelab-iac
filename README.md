# Ansible Playbooks

### Make ansible user on managed nodes example

1. Create User

```bash
sudo useradd ansible
sudo mkdir -p /home/ansible
sudo chown ansible:ansible /home/ansible
sudo chmod 700 /home/ansible
sudo -u ansible mkdir /home/ansible/.ssh
sudo -u ansible chmod 700 /home/ansible/.ssh
```

2. Add Public Key

```bash
sudo -u ansible mkdir /home/ansible/.ssh
sudo -u ansible chmod 700 /home/ansible/.ssh
echo your_public_key_here | sudo tee -a /home/ansible/.ssh/authorized_keys > /dev/null
sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys
sudo chmod 600 /home/ansible/.ssh/authorized_keys
```

3. Add User to sudoers

```bash
sudo visudo

ansible ALL=(ALL) NOPASSWD:<permissions>
```
