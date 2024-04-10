#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")/../out/terraform"

# tofu might not be initialized yet, so we need to run init first
if [ ! -f ".terraform.lock.hcl" ]
then
    tofu init
fi

# We're just going to do it anyway, so no need to show?
# tofu plan -parallelism=100

# read -p "Continue with tofu apply? [yN]" -n 1 -r
# if [[ $REPLY =~ ^[Yy]$ ]]
# then
    tofu apply -auto-approve -parallelism=100
# fi
