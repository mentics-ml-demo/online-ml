#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit

CONTROL_PLANE_ID=$(./get_control_plane_id.sh)
aws ec2-instance-connect ssh --instance-id "${CONTROL_PLANE_ID}" --local-forwarding 7443:localhost:443