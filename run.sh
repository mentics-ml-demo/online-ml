#!/bin/bash

# abort early if any command fails
set -e

source setenv.sh
./kops/1-state-store.sh
./kops/2-gen-tofu.sh
./tofu/3-run-cluster.sh

./argo/1-install-argocd.sh