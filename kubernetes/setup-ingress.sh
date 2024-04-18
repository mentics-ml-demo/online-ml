#!/bin/bash
set -e

DO NOT CREATE INGRESS. Using haproxy instead

cd "$(dirname "${BASH_SOURCE[0]}")"

kubectl create ns ingress
# helm -n ingress upgrade --install ingress-nginx ingress-nginx \
#   --repo https://kubernetes.github.io/ingress-nginx

# kubectl -n ingress apply -f test-ingress.yaml
# # https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml


helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

helm -n ingress install nginx-ingress nginx-stable/nginx-ingress
# --set rbac.create=true