#!/bin/bash

kubectl create ns structurizr

helm repo add virtualroot https://charts.virtualroot.dev/

set -e

helm -n structurizr upgrade --install structurizr virtualroot/structurizr \
  --set users='structurizr=$2a$10$UiE2Tiesubi0KzFibO4HLOxsrmeiwY3iY95sLM92PDOO46LtVFwDS' \
  --set service.type=NodePort
kubectl -n structurizr patch svc structurizr --type=json -p '[{"op":"replace","path":"/spec/ports/0/nodePort","value":32001}]'
