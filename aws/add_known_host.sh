#!/usr/bin/env bash
INSTANCE_ID=$1

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

echo "Adding known hosts for |${INSTANCE_ID}|"

DNS_PUBLIC=$(./get_field.sh "${INSTANCE_ID}" 'PublicDnsName')
IP_PUBLIC=$(./get_field.sh "${INSTANCE_ID}" 'PublicDns')
DNS_PRIVATE=$(./get_field.sh "${INSTANCE_ID}" 'PrivateDnsName')
IP_PRIVATE=$(./get_field.sh "${INSTANCE_ID}" 'PrivateIpAddress')

HOSTS=("$DNS_PUBLIC" "$DNS_PRIVATE" "$IP_PUBLIC" "$IP_PRIVATE")

KEY=$(aws ec2 get-console-output --instance-id "${INSTANCE_ID}" --output text | grep -e "^ssh-ed25519")

for HOST in "${HOSTS[@]}"; do
    if [ -n "$HOST" ] && [ ! "$HOST" = 'null' ]; then
        # Normally, removing and adding would be dangerous,
        # but because we're getting the key from separate channel (system logs), might be ok.
        # echo "Running: ssh-keygen -R \"$HOST\""
        ssh-keygen -R "$HOST"
        # echo "x-$HOST-x x-$KEY-x"
        echo "$HOST $KEY" >> ~/.ssh/known_hosts
    fi
done

# Hash the known hosts file
# TODO: This warns about backup file. Should we delete it? or flag to not create it?
ssh-keygen -H