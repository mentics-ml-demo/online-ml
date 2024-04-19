#!/bin/bash

# abort early if any command fails
set -e

source setenv.sh
./kops/state-store.sh
./kops/gen-terraform.sh
./terraform/run-cluster.sh

# ./kops/kubectl-context.sh
./kubernetes/kube-connection.sh

kubectl create serviceaccount -n default cadmin

kubectl create clusterrolebinding cadmin \
  --clusterrole=cluster-admin \
  --serviceaccount=default:cadmin

./kubernetes/install-dashboard.sh

./kubernetes/token.sh

# ./argo/install-argocd.sh
