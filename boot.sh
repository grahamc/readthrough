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
replace /vagrant/mirror.conf /etc/nginx/sites-enabled/gems.conf

sudo /etc/init.d/nginx restart

