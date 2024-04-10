#!/bin/bash
# This probably won't be used because shutting down the cluster removes argocd, but it might come in handy during development.

kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# kubectl delete namespace argocd