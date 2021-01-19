#!/bin/bash
#set -ex

# sudo touch /home/ubuntu/uninstlling_ansible.txt

# uninstall ansible:
# sudo apt remove ansible -y > /home/ubuntu/uninstlling_ansible.txt

# sudo systemctl unmask unattended-upgrades.service
# sudo systemctl start unattended-upgrades.service

sudo /usr/bin/ansible-galaxy collection install community.crypto