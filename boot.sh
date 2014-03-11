#!/bin/bash

set -e
set -x

sudo apt-get update
sudo apt-get -y install nginx

function replace
{
  sudo cp "$1" "$1.bak"
  sudo cp "$2" "$1"
}

replace /vagrant/nginx.conf /etc/nginx/nginx.conf
replace /vagrant/mirror.conf /etc/nginx/sites-enabled/gems.conf

sudo /etc/init.d/nginx restart

