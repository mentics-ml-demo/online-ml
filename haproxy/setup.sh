#!/bin/bash

# TODO: when implement auto match auto scaling group, may need to save state: https://stackoverflow.com/a/36750445/315734

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

HAPROXY_ID=$("$BASE_DIR"/aws/find_by_name.sh "HAProxy")
"$BASE_DIR"/aws/add_known_host.sh "${HAPROXY_ID}"

haproxy_local="../out/haproxy.cfg"
haproxy_remote="/home/ec2-user/haproxy.cfg"

nginx_local="nginx.conf"
nginx_remote="/home/ec2-user/nginx.conf"
site_local="site"
site_remote="/home/ec2-user/"

pem_local="$HOME/.site.pem"
pem_remote="/home/ec2-user/site.pem"

./make-haproxy.sh ${haproxy_local}

"$BASE_DIR"/aws/public_connect.sh "$HAPROXY_ID" scp ${haproxy_local} ${haproxy_remote}
"$BASE_DIR"/aws/public_connect.sh "$HAPROXY_ID" scp ${nginx_local} ${nginx_remote}
"$BASE_DIR"/aws/public_connect.sh "$HAPROXY_ID" scp ${site_local} ${site_remote}
"$BASE_DIR"/aws/public_connect.sh "$HAPROXY_ID" scp ${pem_local} ${pem_remote}

"$BASE_DIR"/aws/public_connect.sh "$HAPROXY_ID" ssh <<EOT
sudo dnf update
sudo dnf install haproxy nginx -y

sudo cp ${nginx_remote} /etc/nginx/nginx.conf
sudo mkdir -p /srv/www/default && sudo cp -r ${site_remote}/site/* /srv/www/default
sudo systemctl restart nginx

sudo cp ${haproxy_remote} /etc/haproxy/haproxy.cfg
sudo cp ${pem_remote} /etc/haproxy/site.pem
sudo chown haproxy:haproxy /etc/haproxy/site.pem
sudo chmod 444 /etc/haproxy/site.pem
sudo systemctl restart haproxy
EOT
