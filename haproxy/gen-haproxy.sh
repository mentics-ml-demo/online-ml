#!/bin/bash
cat <<EOF
global
    maxconn 256

defaults
    mode http
    timeout connect 2000ms
    timeout client 2000ms
    timeout server 2000ms

frontend https
    bind *:443
    mode tcp
    default_backend control_https

frontend http
    bind *:80
    default_backend structurizr

backend control_https
    mode tcp
EOF

count=0
for ref in $1; do
    echo "    server control${count} ${ref}:443"
    ((count++));
done

cat <<EOF

backend nodes
EOF

count=0
for ref in $2; do
    echo "    server node${count} ${ref}:80"
    ((count++));
done
