#!/bin/bash

# Make paths based on location of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

if kops get all --name "${CLUSTER_NAME}" > /dev/null 2>&1
then
    read -p "Cluster config already exists in kops, delete? [yN]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        kops delete cluster --name "${CLUSTER_NAME}" --unregister --yes
    else
        exit 1
    fi
fi

# Abort early if any script fails
set -e

echo "Generating cluster configuration in kops"
kops create cluster \
    --ssh-public-key ~/.ssh/id_ed25519.pub \
    --name "${CLUSTER_NAME}" \
    --discovery-store "${OIDC_STORE_URL}" \
    --state "${STATE_STORE_URL}" \
    --cloud aws \
    --zones "${ZONES}" \
    --image amazon/al2023-ami-2023.4.20240401.1-kernel-6.1-arm64 \
    --topology private \
    --associate-public-ip=false \
    --control-plane-size "${CONTROL_PLANE_SIZE}" \
    --control-plane-count "${CONTROL_PLANE_COUNT}" \
    --node-size "${NODE_SIZE}" \
    --node-count "${NODE_COUNT}"

echo "Making some modifications to default config"
kops edit ig control-plane-us-west-2b --name "${CLUSTER_NAME}" --set "spec.rootVolume.size=8"
kops edit ig control-plane-us-west-2b --name "${CLUSTER_NAME}" --set "spec.rootVolume.encryption=false"
kops edit ig nodes-us-west-2b --name "${CLUSTER_NAME}" --set "spec.rootVolume.size=8"
kops edit ig nodes-us-west-2b --name "${CLUSTER_NAME}" --set "spec.rootVolume.encryption=false"
kops edit cluster --name "${CLUSTER_NAME}" --set "spec.etcdClusters[0].etcdMembers[0].volumeSize=8"
kops edit cluster --name "${CLUSTER_NAME}" --set "spec.etcdClusters[0].etcdMembers[0].encryptedVolume=false"
kops edit cluster --name "${CLUSTER_NAME}" --set "spec.etcdClusters[1].etcdMembers[0].volumeSize=8"
kops edit cluster --name "${CLUSTER_NAME}" --set "spec.etcdClusters[1].etcdMembers[0].encryptedVolume=false"
kops edit cluster --name "${CLUSTER_NAME}" --unset "spec.api.loadBalancer"

# If you want to use spot instances, comment the line with target=terraform above, and uncomment the following:
# kops edit ig control-plane-us-west-2b \
#     --name ${CLUSTER_NAME} \
#     --state ${STATE_STORE_URL} \
#     --set "spec.mixedInstancesPolicy.instances=t4g.small" \
#     --set "spec.mixedInstancesPolicy.onDemandBase=0" \
#     --set "spec.mixedInstancesPolicy.onDemandAboveBase=0" \
#     --set "spec.mixedInstancesPolicy.spotAllocationStrategy=lowest-price"

# kops edit ig node-us-west-2b \
#     --name ${CLUSTER_NAME} \
#     --state ${STATE_STORE_URL} \
#     --set "spec.mixedInstancesPolicy.instances=t4g.small" \
#     --set "spec.mixedInstancesPolicy.onDemandBase=0" \
#     --set "spec.mixedInstancesPolicy.onDemandAboveBase=0" \
#     --set "spec.mixedInstancesPolicy.spotAllocationStrategy=lowest-price"

echo "Exporting kops cluster config to terraform"
kops update cluster \
    --name "${CLUSTER_NAME}" \
    --state "${STATE_STORE_URL}" \
    --admin \
    --target=terraform

echo "Exporting kops cluster config out/kops-${CLUSTER_NAME}.yaml"
kops get all "${CLUSTER_NAME}" -o yaml > out/kops-"${CLUSTER_NAME}".yaml

rm -rf ../out
mv out ..


# was trying to do this without having to create kops resources, but couldn't make it work.
# Asked on stackoverflow: https://stackoverflow.com/questions/78305385/with-kops-after-generating-and-editing-the-yaml-file-how-can-i-generate-terraf
    # --output yaml > ${CLUSTER_NAME}.yaml
    # --set controlPlane.mixedInstancesPolicy.enabled=true \
    # --set spec.mixedInstancesPolicy.spotAllocationStrategy=lowest-price \
    # --set "spec.etcdClusters[0].etcdMembers[0].instanceGroup.spec.maxSize=3" \
    # --set "instanceGroups[0].mixedInstancesPolicy.enabled=true" \
