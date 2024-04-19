#!/bin/bash
if [ -z "$1" ]; then
    echo "Must pass in the output path"
    exit 1
fi
OUTPUT_PATH="$(pwd)/$1"
echo "$OUTPUT_PATH"

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"
WORK_DIR=$(pwd)

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

cd "${WORK_DIR}"
./gen-haproxy.sh "${control_refs}" "${nodes_refs}" > "${OUTPUT_PATH}"
