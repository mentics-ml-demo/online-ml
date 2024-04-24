#!/bin/bash
INSTANCE_ID=$1
CMD=$2
TARGET1=$3
TARGET2=$4

PUBLIC_DNS=$("$BASE_DIR"/aws/get_field.sh "${INSTANCE_ID}" PublicDnsName)

echo "Public connection to ${PUBLIC_DNS}"

if [ "$CMD" == 'ssh' ]; then
    if [ -n "$TARGET1" ]; then
        ssh -t -i ~/.ssh/awsec2.pem ec2-user@"${PUBLIC_DNS}" "$TARGET1"
    else
        ssh -i ~/.ssh/awsec2.pem ec2-user@"${PUBLIC_DNS}"
    fi
elif [ "$CMD" == 'scp' ]; then
    scp -r -i ~/.ssh/awsec2.pem "$TARGET1" "ec2-user@${PUBLIC_DNS}:$TARGET2"
elif [ "$CMD" == 'pcs' ]; then
    scp -r -i ~/.ssh/awsec2.pem "ec2-user@${PUBLIC_DNS}:$TARGET1" "$TARGET2"
fi
