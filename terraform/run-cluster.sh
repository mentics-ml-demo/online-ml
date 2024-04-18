#!/bin/bash

set -e

cd "$(dirname "${BASH_SOURCE[0]}")"


if [ -f "${HOME}/.terraform.tfvars" ]; then
    OPTIONS="-var-file ~/.terraform.tfvars"
    echo "Using terraform variables from ${HOME}/.terraform.tfvars"
else
    OPTIONS=""
fi


# copy files over to work dirs

cp *.tf ../out/terraform
cp ../out/terraform/kubernetes.tf ../out/kubernetes.tf.orig
patch ../out/terraform/kubernetes.tf kubernetes.tf.patch
mkdir ../out/static
cp static/*.tf ../out/static


# process static terraform files

cd "../out/static"
if [ ! -f "terraform.tfstate" ]
then
    echo "Initializing terraform for static"
    terraform init
fi

echo "Executing terraform apply for static: creating static cloud resources"
terraform apply ${OPTIONS} -auto-approve -parallelism=100

# Might need this if it errors on it already existing:
# terraform import aws_iam_policy.ec2_instance_connect_policy arn:aws:iam::064371530540:policy/Ec2InstanceConnectAll


# process all other terraform files

cd "../terraform"

# terraform might not be initialized yet, so we need to run init first
if [ ! -f "terraform.tfstate" ]
then
    echo "Initializing terraform for general"
    terraform init
fi

# echo "Importing static resources into terraform"
# # TODO: ignore errors if it doesn't exist... need to create it
# terraform import aws_default_vpc.default vpc-0d622d74
# terraform import aws_default_subnet.default subnet-43398d3a
# terraform import aws_security_group.allow_ssh sg-097a102a21a4aac7c
# terraform import aws_ec2_instance_connect_endpoint.ec2_access eice-0b6ac262a0ec9ab69

echo "Executing terraform apply: creating cloud resources"
terraform apply ${OPTIONS} -auto-approve -parallelism=100

terraform output > ../tf.output