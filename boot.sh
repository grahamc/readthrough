#!/bin/bash

set -e
set -x

sudo apt-get update
sudo apt-get -y install nginx

function replace
{
  if [ -f "$2" ]; then
    sudo cp "$2" "$2.bak"
  fi
  sudo cp "$1" "$2"
}

replace /vagrant/nginx.conf /etc/nginx/nginx.conf
replace /vagrant/mirror.conf /etc/nginx/conf.d/gems.conf

sudo mkdir -p /var/www/nginx_temp
sudo chown www-data:www-data /var/www/nginx_temp

sudo /etc/init.d/nginx restart

