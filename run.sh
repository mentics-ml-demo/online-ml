#!/bin/bash

# abort early if any command fails
set -e -x

source setenv.sh
./kops/state-store.sh
./kops/gen-terraform.sh
./terraform/run-cluster.sh

aws ec2 describe-instances > out/instances.json

./haproxy/setup.sh

# ./kops/kubectl-context.sh
./kubernetes/kube-connection.sh

kubectl create serviceaccount -n default cadmin

kubectl create clusterrolebinding cadmin \
  --clusterrole=cluster-admin \
  --serviceaccount=default:cadmin

./kubernetes/install-dashboard.sh

./structurizr/install.sh
./scylladb/configure.sh
./redpanda/install.sh

./argo/install-argocd.sh

./kubernetes/config-secrets.sh

./kubernetes/token.sh
