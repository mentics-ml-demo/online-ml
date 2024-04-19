#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

cd ../out/terraform

# mv static.tf ../
terraform destroy -var-file ~/.terraform.tfvars -auto-approve -parallelism=100
