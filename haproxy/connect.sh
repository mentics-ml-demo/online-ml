#!/bin/bash
# Pass in arguments to run commands instead of entering a shell

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

HAPROXY_ID=$("$BASE_DIR"/aws/find_by_name.sh "HAProxy")
# INSTANCE_ID=$(../aws/find_instance.sh "Tags[].Value" "HAProxy")
PUBLIC_DNS=$(../aws/get_field.sh "${HAPROXY_ID}" PublicDnsName)

echo "Connecting to ${PUBLIC_DNS}"

if [ -n "$1" ]; then
    if [ "$1" == 'scp' ]; then
        scp -r -i ~/.ssh/awsec2.pem "$2" "ec2-user@${PUBLIC_DNS}:$3"
    elif [ "$1" == 'pcs' ]; then
        scp -r -i ~/.ssh/awsec2.pem "ec2-user@${PUBLIC_DNS}:$2" "$3"
    else
        ssh -t -i ~/.ssh/awsec2.pem ec2-user@"${PUBLIC_DNS}" "$1"
    fi
else
    ssh -i ~/.ssh/awsec2.pem ec2-user@"${PUBLIC_DNS}"
fi

