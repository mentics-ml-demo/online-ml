#!/usr/bin/env bash
FIELDNAME=$1
VALUE=$2

BASE_DIR=$(dirname "${BASH_SOURCE[0]}")/..

# TODO: filter for active instances

INSTANCE_IDS=($(jq -r ".Reservations[].Instances[] | select(.${FIELDNAME} == \"${VALUE}\") | .InstanceId" < "${BASE_DIR}/out/instances.json"))
# I saw duplicate results, so grab first one
echo $INSTANCE_IDS