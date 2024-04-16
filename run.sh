#!/bin/bash

# abort early if any command fails
set -e

source setenv.sh
./kops/state-store.sh
./kops/gen-tofu.sh
./tofu/run-cluster.sh

# # DONE: this can be added as tf file copied into out/terraform and have it reference the created subnet id: aws_subnet.utility-us-west-2b-mentics-demo-k8s-local.id
# SUBNET_ID=$(aws ec2 describe-subnets \
#     --output text --query 'Subnets[*].SubnetId' \
#     --filters "Name=tag:Name,Values=utility-${ZONES}.${CLUSTER_NAME}" 'Name=state,Values=available')

# # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-instance-connect-endpoint.html
# aws ec2 create-instance-connect-endpoint --subnet-id $SUBNET_ID --tag-specifications "ResourceType=instance-connect-endpoint,Tags=[{Key=Name,Value=EC2 Access Endpoint}]"

./kops/kubectl-context.sh

kubectl create serviceaccount -n default cadmin

kubectl create clusterrolebinding cadmin \
  --clusterrole=cluster-admin \
  --serviceaccount=default:cadmin

./install-k8s-dashboard.sh

./token.sh

# ./argo/install-argocd.sh