#!/usr/bin/env bash
NAME=$1
USER=${2:-ec2-user}
if [ -n "$3" ]; then
    FROM_PORT=$3
    TO_PORT=$4
fi

INSTANCE_ID=$("$BASE_DIR"/aws/find_by_name.sh "${NAME}")

aws ec2-instance-connect send-ssh-public-key \
    --region us-west-2 \
    --availability-zone us-west-2b \
    --instance-id "${INSTANCE_ID}" \
    --instance-os-user "${USER}" \
    --ssh-public-key "file://${HOME}/.ssh/id_ed25519.pub"

echo "Connecting to ec2 instance id ${INSTANCE_ID}"

if [ -n "$FROM_PORT" ]; then
    aws ec2-instance-connect ssh --instance-id "${INSTANCE_ID}" --os-user "$USER" --local-forwarding "${FROM_PORT}:localhost:${TO_PORT}"
else
    aws ec2-instance-connect ssh --instance-id "${INSTANCE_ID}" --os-user "$USER"
fi
