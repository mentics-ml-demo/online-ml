#!/bin/bash
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

cd ../out/terraform

tofu destroy -auto-approve -parallelism=100
