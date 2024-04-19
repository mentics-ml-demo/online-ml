#!/bin/bash

# TODO: when implement auto match auto scaling group, may need to save state: https://stackoverflow.com/a/36750445/315734

cd "$(dirname "${BASH_SOURCE[0]}")"

haproxy_local="../out/haproxy.cfg"
haproxy_remote="/home/ec2-user/haproxy.cfg"

nginx_local="nginx.conf"
nginx_remote="/home/ec2-user/nginx.conf"
site_local="site"
site_remote="/home/ec2-user/"

./make-conf.sh ${haproxy_local}

./connect.sh scp ${haproxy_local} ${haproxy_remote}
./connect.sh scp ${nginx_local} ${nginx_remote}
./connect.sh scp ${site_local} ${site_remote}

./connect.sh <<EOT
sudo dnf update
sudo dnf install haproxy nginx -y
sudo cp ${haproxy_remote} /etc/haproxy/haproxy.cfg
sudo cp ${nginx_remote} /etc/nginx/nginx.conf
sudo mkdir -p /srv/www/default && sudo cp -r ${site_remote}/site/* /srv/www/default
sudo systemctl restart haproxy
EOT
