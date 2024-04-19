#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

haproxy_local="../out/haproxy.cfg"
haproxy_remote="/home/ec2-user/haproxy.cfg"

./make-conf.sh ${haproxy_local}

./connect.sh scp ${haproxy_local} ${haproxy_remote}
./connect.sh <<EOT
sudo cp ${haproxy_remote} /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
EOT
