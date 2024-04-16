#!/bin/bash

# TODO: add special handling for resources in the static directory

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"

cp *.tf ../out/terraform

cd "../out/terraform"

# tofu might not be initialized yet, so we need to run init first
if [ ! -f ".terraform.lock.hcl" ]
then
    echo "Terraform needs to be initialized first"
    tofu init
fi

tofu import aws_iam_policy.ec2_instance_connect_policy arn:aws:iam::064371530540:policy/Ec2InstanceConnectAll
tofu import aws_default_vpc.default vpc-0d622d74
tofu import aws_default_subnet.default subnet-43398d3a
tofu import aws_security_group.allow_ssh sg-0c0763d88901e224d
tofu import aws_ec2_instance_connect_endpoint.ec2_access eice-0637bcf1cf7d5c1cf

echo "Executing tofu apply: creating cloud resources"
tofu apply -auto-approve -parallelism=100
