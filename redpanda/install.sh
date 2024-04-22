#!/bin/bash

# REDPANDA_ID=$(aws ec2 describe-instances \
#     --output text --query 'Reservations[*].Instances[*].{InstanceId,PrivateIpAddress}' \
#     --filters 'Name=tag:Name,Values=redpanda' 'Name=instance-state-name,Values=running')

response=$(aws ec2 describe-instances \
    --output text --query 'Reservations[].Instances[].{InstanceID:InstanceId,ip:PrivateIpAddress}' \
    --filters 'Name=tag:Name,Values=redpanda*' 'Name=instance-state-name,Values=running')
vars=($response)
INSTANCE_ID=${vars[0]}
PRIVATE_IP=${vars[1]}
echo "Installing redpanda into $INSTANCE_ID with ip $PRIVATE_IP"

aws ec2-instance-connect send-ssh-public-key \
    --region us-west-2 \
    --availability-zone us-west-2b \
    --instance-id "${INSTANCE_ID}" \
    --instance-os-user ec2-user \
    --ssh-public-key file://"${HOME}"/.ssh/id_ed25519.pub

cat <<EOT | aws ec2-instance-connect ssh --instance-id "${INSTANCE_ID}" --os-user ec2-user
curl -1sLf 'https://dl.redpanda.com/nzc4ZYQK3WRGd9sy/redpanda/cfg/setup/bash.rpm.sh' > bash.rpm.sh
cat bash.rpm.sh | sudo -E bash && sudo yum install redpanda -y
cat bash.rpm.sh | sudo -E bash && sudo yum install redpanda-console -y
sudo rpk redpanda config bootstrap --self ${PRIVATE_IP} --advertised-kafka ${PRIVATE_IP} --ips ${PRIVATE_IP}
sudo rpk redpanda config set redpanda.empty_seed_starts_cluster false
sudo systemctl start redpanda-tuner redpanda
sudo systemctl start redpanda-console
sudo systemctl status redpanda-console
rpk cluster info
EOT
