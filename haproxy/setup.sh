#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

# This is run after terraform has created the instance

cd ../out/terraform
json_output=$(terraform output -json node_autoscaling_group_ids)
NODES_ASG_ID=${json_output//[\]\[\"]/}

json_output=$(terraform output -json master_autoscaling_group_ids)
CONTROL_ASG_ID=${json_output//[\]\[\"]/}

echo "Getting instance list for auto scaling group ${NODES_ASG_ID}"
nodes_refs=$(aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=${NODES_ASG_ID}" --query "Reservations[*].Instances[*].[PrivateDnsName]" --output text)
echo "Found instances: ${nodes_refs}"

echo "Getting instance list for auto scaling group ${CONTROL_ASG_ID}"
control_refs=$(aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=${CONTROL_ASG_ID}" --query "Reservations[*].Instances[*].[PrivateDnsName]" --output text)
echo "Found instances: ${control_refs}"

# TODO: when auto match asg, may need to save state: https://stackoverflow.com/a/36750445/315734

LOCAL_PATH="../out/haproxy.conf"
REMOTE_PATH="/home/ec2-user/haproxy.conf"

./gen-haproxy.sh "${control_refs}" "${nodes_refs}" > ${LOCAL_PATH}
./connect.sh scp LOCAL_PATH ${REMOTE_PATH}
./haproxy/connect.sh "sudo dnf update && sudo dnf install haproxy -y && sudo cp ${REMOTE_PATH} /etc/haproxy/haproxy.conf"
