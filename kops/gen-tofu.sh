#!/bin/bash

# Abort early if any script fails
set -e

# Make paths based on location of this script
# parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
# pushd ${parent_path} > /dev/null
cd "$(dirname "${BASH_SOURCE[0]}")"

kops create cluster \
    --name ${CLUSTER_NAME} \
    --discovery-store ${OIDC_STORE_URL} \
    --state ${STATE_STORE_URL} \
    --cloud aws \
    --zones ${ZONES} \
    --image amazon/al2023-ami-2023.4.20240401.1-kernel-6.1-arm64 \
    --control-plane-size ${CONTROL_PLANE_SIZE} \
    --control-plane-count ${CONTROL_PLANE_COUNT} \
    --node-size ${NODE_SIZE} \
    --node-count ${NODE_COUNT} \
    --target=terraform

# If you want to use spot instances, comment the line with target=terraform above, and uncomment the following:
# kops edit ig control-plane-us-west-2b \
#     --name ${CLUSTER_NAME} \
#     --state ${STATE_STORE_URL} \
#     --set "spec.mixedInstancesPolicy.instances=t4g.small" \
#     --set "spec.mixedInstancesPolicy.onDemandBase=0" \
#     --set "spec.mixedInstancesPolicy.onDemandAboveBase=0" \
#     --set "spec.mixedInstancesPolicy.spotAllocationStrategy=lowest-price"

# kops edit ig control-plane-us-west-2b \
#     --name ${CLUSTER_NAME} \
#     --state ${STATE_STORE_URL} \
#     --set "spec.mixedInstancesPolicy.instances=t4g.small" \
#     --set "spec.mixedInstancesPolicy.onDemandBase=0" \
#     --set "spec.mixedInstancesPolicy.onDemandAboveBase=0" \
#     --set "spec.mixedInstancesPolicy.spotAllocationStrategy=lowest-price"

# kops update cluster \
#     --name ${CLUSTER_NAME} \
#     --state ${STATE_STORE_URL} \
#     --target=terraform

# was trying to do this without having to create kops resources, but couldn't make it work.
# Asked on stackoverflow: https://stackoverflow.com/questions/78305385/with-kops-after-generating-and-editing-the-yaml-file-how-can-i-generate-terraf
    # --output yaml > ${CLUSTER_NAME}.yaml
    # --set controlPlane.mixedInstancesPolicy.enabled=true \
    # --set spec.mixedInstancesPolicy.spotAllocationStrategy=lowest-price \
    # --set "spec.etcdClusters[0].etcdMembers[0].instanceGroup.spec.maxSize=3" \
    # --set "instanceGroups[0].mixedInstancesPolicy.enabled=true" \
