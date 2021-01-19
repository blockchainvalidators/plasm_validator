#!/bin/bash
#set -ex
# get the public ip address
mycmd=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
#replace ip_address with the current ip in the nginx.conf file
sudo sed -i "s/ip_address/$mycmd/g" /etc/nginx/nginx.conf
# restart nginx
sudo systemctl restart nginx
