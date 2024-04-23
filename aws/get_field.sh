#!/usr/bin/env bash
INSTANCE_ID=$1
FIELDNAME=$2

BASE_DIR=$(dirname "${BASH_SOURCE[0]}")/..
jq -r ".Reservations[].Instances[] | select(.InstanceId == \"${INSTANCE_ID}\") | .${FIELDNAME}" < "${BASE_DIR}/out/instances.json"
