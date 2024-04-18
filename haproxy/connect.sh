#!/bin/bash
# Pass in arguments to run commands instead of entering a shell

cd "$(dirname "${BASH_SOURCE[0]}")"

if [ -f "../out/lb-ip.txt" ]; then
    echo "Using dns name from out/lb-ip.txt"
    PUBLIC_DNS=$(cat ../out/lb-ip.txt)
else
    res=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=["HAProxy"]" --query "Reservations[*].Instances[*].[PublicDnsName]" --output text)
    PUBLIC_DNS=${res//[ $'\n']/}
    echo ${PUBLIC_DNS} > ../out/lb-ip.txt
    echo "Connecting to ${PUBLIC_DNS}"
fi

if [ -n "$1" ]; then
    if [ "$1" == 'scp' ]; then
        scp $2 ec2-user@${PUBLIC_DNS}:$3
    else
        ssh -t -i ~/.ssh/awsec2.pem ec2-user@${PUBLIC_DNS} "$1"
    fi
else
    ssh -i ~/.ssh/awsec2.pem ec2-user@${PUBLIC_DNS}
fi

