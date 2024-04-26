#!/bin/bash
set -e

./terraform/shutdown-cluster.sh
./kops/cleanup.sh

# Remove ssh known hosts because they will likely change next time.
# TODO: we should limit it to known instances in case other instances were added by other processes.
echo "Removing known hosts from ssh"
IPS=$(aws ec2 describe-instances --query 'Reservations[*]. Instances[*]. PublicIpAddress' --output text)
for IP in $IPS; do
  ssh-keygen -R "$IP"
done

rm out/instances.json