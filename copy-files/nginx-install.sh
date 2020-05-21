#!/usr/bin/env bash

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

apt update -y
apt install nginx -y

cp /tmp/index.html /var/www/html/

systemctl enable nginx
systemctl start nginx