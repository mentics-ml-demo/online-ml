#!/bin/bash
CONTROL=$1
NODES=$2

# echo
# echo -e "CONTROL:\n${CONTROL}"
# echo
# echo -e "NODES:\n${NODES}"
# echo

# exit 1

cat <<EOF
global
    maxconn 256

defaults
    mode http
    timeout connect 2000ms
    timeout client 2000ms
    timeout server 2000ms

frontend SSL_Termination
    bind *:443 transparent ssl crt /etc/haproxy/site.pem
    mode http
    acl acl_structurizr hdr_sub(host) -i structurizr
    acl acl_k8s_dashboard hdr_sub(host) -i dashboard
    acl acl_k8s_api hdr_sub(host) -i api

    use_backend dashboard_nodeport if acl_k8s_dashboard
    use_backend api if acl_k8s_api
    default_backend default

backend default
    server default localhost:80

backend api
    server default localhost:80
EOF

# count=0
# for ref in "$CONTROL"; do
#     echo "    server control${count} ${ref}:443"
#     ((count++));
# done

cat <<EOF

backend dashboard_nodeport
EOF

count=0
for ref in $NODES; do
    echo "    server https_nodeport_${count} ${ref}:32000 ssl verify none"
    ((count++));
done
