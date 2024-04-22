#!/bin/bash
CONTROL=$1
NODES=$2

cat <<EOF
global
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 5000ms
    timeout server 5000ms

frontend HTTP_Termination
    bind *:80
    mode http
    default_backend default

frontend SSL_Termination
    bind *:443 transparent ssl crt /etc/haproxy/site.pem
    mode http
    acl acl_k8s_api hdr_sub(host) -i api
    acl acl_k8s_dash hdr_sub(host) -i dash.k8s
    acl acl_structurizr hdr_sub(host) -i structurizr
    acl acl_argocd hdr_sub(host) -i cd.k8s

    use_backend api if acl_k8s_api
    use_backend dash_nodeport if acl_k8s_dash
    use_backend structurizr if acl_structurizr
    use_backend argocd if acl_argocd
    default_backend default

backend default
    server default localhost:8081
EOF

## Kubernetes API
cat <<EOF
backend api
EOF
count=1
for ref in $CONTROL; do
    echo "    server api_${count} ${ref}:443 ssl verify none"
    ((count++));
done

## Kubernetes Dashboard
cat <<EOF
backend dash_nodeport
EOF

count=1
for ref in $NODES; do
    echo "    server dash_${count} ${ref}:32000 ssl verify none"
    ((count++));
done

## Structurizr
cat <<EOF
backend structurizr
EOF

count=1
for ref in $NODES; do
    echo "    server structurizr_${count} ${ref}:32001"
    ((count++));
done

## ArgoCD
cat <<EOF
backend argocd
EOF

count=1
for ref in $NODES; do
    echo "    server argocd_${count} ${ref}:32013 ssl verify none"
    ((count++));
done
