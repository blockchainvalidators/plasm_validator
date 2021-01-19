#!/bin/bash
set -ex

# Disable unattend upgrades inteferring with the apt-get update
# This was causing an issue when running ansible playbooks with packer
# Several workarounds and this is temporary until I find a better fix
sudo systemctl mask unattended-upgrades.service
sudo systemctl stop unattended-upgrades.service

# Make sure unattend is off before proceeding
while systemctl is-active --quiet unattended-upgrades.service; do sleep 1; done

# install ansible on the ec2 instance
sudo apt-get update
sudo apt-get -qq install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get -qq install ansible