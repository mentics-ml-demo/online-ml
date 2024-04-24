#!/bin/bash

BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")

# REDPANDA_ID=$(aws ec2 describe-instances \
#     --output text --query 'Reservations[*].Instances[*].{InstanceId,PrivateIpAddress}' \
#     --filters 'Name=tag:Name,Values=redpanda' 'Name=instance-state-name,Values=running')

REDPANDA_ID=$("$BASE_DIR"/aws/find_by_name.sh "redpanda")
PRIVATE_IP=$("$BASE_DIR"/aws/get_field.sh "${REDPANDA_ID}" PrivateIpAddress)

# response=$(aws ec2 describe-instances \
#     --output text --query 'Reservations[].Instances[].{InstanceID:InstanceId,ip:PrivateIpAddress}' \
#     --filters 'Name=tag:Name,Values=redpanda*' 'Name=instance-state-name,Values=running')
# vars=($response)
# REDPANDA_ID=${vars[0]}
# PRIVATE_IP=${vars[1]}

"$BASE_DIR"/aws/add_known_host.sh "${REDPANDA_ID}"

echo "Installing redpanda into $REDPANDA_ID with ip $PRIVATE_IP"

aws ec2-instance-connect send-ssh-public-key \
    --region us-west-2 \
    --availability-zone us-west-2b \
    --instance-id "${REDPANDA_ID}" \
    --instance-os-user ec2-user \
    --ssh-public-key file://"${HOME}"/.ssh/id_ed25519.pub

cat <<EOT | aws ec2-instance-connect ssh --instance-id "${REDPANDA_ID}" --os-user ec2-user
curl -1sLf 'https://dl.redpanda.com/nzc4ZYQK3WRGd9sy/redpanda/cfg/setup/bash.rpm.sh' > bash.rpm.sh
cat bash.rpm.sh | sudo -E bash && sudo yum install redpanda -y
cat bash.rpm.sh | sudo -E bash && sudo yum install redpanda-console -y
sudo rpk redpanda config bootstrap --self ${PRIVATE_IP} --advertised-kafka ${PRIVATE_IP} --ips ${PRIVATE_IP}
sudo rpk redpanda config set redpanda.empty_seed_starts_cluster false
cat <<EOF | sudo tee /etc/redpanda/redpanda-console-config.yaml
kafka:
  brokers: "${PRIVATE_IP}:9092"
EOF
sudo systemctl start redpanda-tuner redpanda
sudo systemctl start redpanda-console
sudo systemctl status redpanda-console
rpk cluster info
EOT

"$BASE_DIR"/kubernetes/add-config.sh REDPANDA_ENDPOINT "${PRIVATE_IP}:9092"
