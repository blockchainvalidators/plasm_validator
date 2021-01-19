#!/bin/bash
set -ex

# uninstall ansible:
sudo apt remove ansible -y > /home/ubuntu/uninstlling_ansible.txt

# Remove associated ansible files and directories
sudo rm -rf /etc/ansible
sudo rm -rf /var/tmp/ansible
sudo rm -rf /usr/share/doc/ansible
sudo rm -rf /usr/lib/python2.7/dist-packages/ansible
sudo rm -rf /usr/bin/ansible
sudo rm -rf /var/lib/dpkg/info/ansible.list
sudo rm -rf /var/cache/apt/archives/ansible_2.9.16-1ppa~bionic_all.deb
sudo rm -rf /etc/apt/trusted.gpg.d/ansible_ubuntu_ansible.gpg
sudo rm -rf /etc/apt/sources.list.d/ansible-ubuntu-ansible-bionic.list
sudo rm -rf /home/ubuntu/uninstlling_ansible.txt
sudo rm -rf /home/ubuntu/.ansible

# turn on unattended upgrades
sudo systemctl unmask unattended-upgrades.service
sudo systemctl start unattended-upgrades.service