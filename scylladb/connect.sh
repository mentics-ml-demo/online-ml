#!/bin/bash

SCYLLADB_ID=$(aws ec2 describe-instances \
    --output text --query 'Reservations[*].Instances[*].InstanceId' \
    --filters 'Name=tag:Name,Values=ScyllaDB' 'Name=instance-state-name,Values=running')

aws ec2-instance-connect send-ssh-public-key \
    --region us-west-2 \
    --availability-zone us-west-2b \
    --instance-id ${SCYLLADB_ID} \
    --instance-os-user scyllaadm \
    --ssh-public-key file://${HOME}/.ssh/id_ed25519.pub

echo "Connecting to ec2 instance id ${SCYLLADB_ID}"

aws ec2-instance-connect ssh --instance-id ${SCYLLADB_ID} --os-user scyllaadm

aws ec2-instance-connect ssh --instance-id ${SCYLLADB_ID} --os-user scyllaadm --local-forwarding 9042:localhost:9042
