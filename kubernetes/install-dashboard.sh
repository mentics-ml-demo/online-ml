#!/bin/bash
set -e

# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

# kubectl rollout status deployment kubernetes-dashboard-web -n kubernetes-dashboard

echo "Waiting for rollout..."
kubectl wait -n kubernetes-dashboard --for=condition=ready pod --selector=app.kubernetes.io/name=kubernetes-dashboard-web

echo "Forwarding port"
nohup kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443 > /dev/null 2>&1 &

