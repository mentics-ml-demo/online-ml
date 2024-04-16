#!/bin/bash

# Abort early if any script fails
set -e
# Make paths based on location of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

kubectl create namespace rpanda
kubectl config set-context --current --namespace=rpanda

# https://docs.redpanda.com/current/deploy/deployment-option/self-hosted/kubernetes/local-guide/

helm repo add jetstack https://charts.jetstack.io
helm repo add redpanda https://charts.redpanda.com
helm repo update

helm install cert-manager jetstack/cert-manager --set installCRDs=true --namespace cert-manager --create-namespace

kubectl kustomize "https://github.com/redpanda-data/redpanda-operator//src/go/k8s/config/crd?ref=v2.1.16-23.3.11" \
    | kubectl apply -f -

helm upgrade --install redpanda-controller redpanda/operator \
  --namespace rpanda \
  --set image.tag=v2.1.16-23.3.11 \
  --create-namespace

# kubectl get redpanda --namespace rpanda --watch
kubectl wait --for=condition=ready pod redpanda-0 --namespace rpanda

kubectl apply -f redpanda-cluster.yaml --namespace rpanda

kubectl --namespace rpanda port-forward svc/redpanda-console 8020:8080 > /dev/null 2>&1 &
echo "Access the redpanda web console at http://localhost:8020/"

# TODO: create topic