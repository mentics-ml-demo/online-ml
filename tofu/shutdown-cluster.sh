#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

cd ../out/terraform

mv static.tf ../
tofu destroy -auto-approve -parallelism=100
