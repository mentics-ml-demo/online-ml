#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")/out/terraform"

# tofu might not be initialized yet, so we need to run init first
tofu plan
if [ $? -ne 0 ]
then
    tofu init
    set -e
    tofu plan
fi
set -e

read -p "Continue with tofu apply? [yN]" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    tofu apply -auto-approve
fi

