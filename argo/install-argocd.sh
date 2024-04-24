#!/bin/bash

kubectl create namespace argocd

set -e

kubectl -n argocd apply -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl -n argocd wait pod argocd-application-controller-0 --for=condition=ready
sleep 0.2
# kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
LOCAL_PORT=8010
kubectl port-forward svc/argocd-server -n argocd ${LOCAL_PORT}:443 &

# ARGOCD_SERVER_URL=https://localhost:8001
ARGOCD_SERVER=localhost:${LOCAL_PORT}
# echo "export ARGOCD_SERVER=${ARGOCD_SERVER}"

TEMP_PASSWORD=$(argocd admin initial-password -n argocd | head -n 1)
# export TEMP_PASSWORD

argocd login ${ARGOCD_SERVER} --insecure --username admin --password "${TEMP_PASSWORD}"

# Generate a url safe password.
password() {
  local length=${1:-"20"}
  cat /dev/urandom | tr -dc A-Za-z0-9~_- | head -c $length && echo
}

ARGO_PASSWORD=$(password)
echo "${ARGO_PASSWORD}" > ~/.argocd-password
echo "wrote argocd password to ~/.argocd-password"

argocd account update-password --current-password ${TEMP_PASSWORD} --new-password ${ARGO_PASSWORD}

kubectl -n argocd patch svc/argocd-server --patch '{ "spec": { "type": "NodePort", "ports": [{ "port":80, "nodePort": 32010 }, { "port":443, "nodePort": 32013 }] } }' -o yaml --type strategic

# echo "Access web UI at https://${ARGOCD_SERVER}"

# # TODO: this is just a sample app for testing. remove when testing completed.
# argocd app create guestbook --repo https://github.com/argoproj/argocd-example-apps.git --path guestbook --dest-server https://kubernetes.default.svc --dest-namespace default
# argocd app get guestbook
# argocd app sync guestbook

