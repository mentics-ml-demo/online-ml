#!/bin/bash
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)

SCYLLADB_ID=$("$BASE_DIR"/aws/find_by_name.sh "ScyllaDB")

"$BASE_DIR"/aws/add_known_host.sh "${SCYLLADB_ID}"

# SCYLLADB_ID=$(aws ec2 describe-instances \
#     --output text --query 'Reservations[*].Instances[*].InstanceId' \
#     --filters 'Name=tag:Name,Values=ScyllaDB' 'Name=instance-state-name,Values=running')

# aws ec2-instance-connect send-ssh-public-key \
#     --region us-west-2 \
#     --availability-zone us-west-2b \
#     --instance-id ${SCYLLADB_ID} \
#     --instance-os-user scyllaadm \
#     --ssh-public-key file://${HOME}/.ssh/id_ed25519.pub

# echo "Executing DDL on scylladb on ec2 instance id ${SCYLLADB_ID}"

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
echo -e "cqlsh\n$(cat ddl.cql)" | aws ec2-instance-connect ssh --instance-id "${SCYLLADB_ID}" --os-user scyllaadm

IP=$("${BASE_DIR}/aws/get_field.sh" "${SCYLLADB_ID}" PrivateIpAddress)
"$BASE_DIR"/kubernetes/add-config.sh SCYLLADB_ENDPOINT "${IP}:9042"
