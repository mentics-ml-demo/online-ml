#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

CONTROL_PLANE_ID=$(aws ec2 describe-instances \
    --output text --query 'Reservations[*].Instances[*].InstanceId' \
    --filters 'Name=tag:Name,Values=control-plane-*' 'Name=instance-state-name,Values=running')

aws ec2-instance-connect send-ssh-public-key \
    --region us-west-2 \
    --availability-zone us-west-2b \
    --instance-id "${CONTROL_PLANE_ID}" \
    --instance-os-user ec2-user \
    --ssh-public-key file://"${HOME}"/.ssh/id_ed25519.pub

TEMP_KUBE_FILE=/tmp/kubeconfig
echo "cat ~/.kube/config" | aws ec2-instance-connect ssh --instance-id "${CONTROL_PLANE_ID}" --os-user ec2-user | sed -n '/apiVersion/,$p' > ${TEMP_KUBE_FILE}

get_data() {
    KEY=$1
    cat ${TEMP_KUBE_FILE} | grep "${KEY}" | tr -s ' ' | cut -d ' ' -f 3
}

KUBE_CERT_AUTH=$(get_data 'certificate-authority-data')
KUBE_CLIENT_CERT=$(get_data 'client-certificate-data')
KUBE_CLIENT_KEY=$(get_data 'client-key-data')
export KUBE_CERT_AUTH KUBE_CLIENT_CERT KUBE_CLIENT_KEY

envsubst < kubeconfig.template > ~/.kube/config

echo "Forwarding 7443 to control-plane:443"
nohup aws ec2-instance-connect ssh --instance-id "${CONTROL_PLANE_ID}" --local-forwarding 7443:localhost:443 > /dev/null 2>&1 &
