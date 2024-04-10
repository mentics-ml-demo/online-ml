#!/bin/bash

# abort early if any command fails
set -e

source setenv.sh
./kops/state-store.sh
./kops/gen-tofu.sh
./tofu/run-cluster.sh
./kops/kubectl-context.sh

./argo/install-argocd.sh