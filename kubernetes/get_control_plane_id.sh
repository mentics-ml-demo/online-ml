#!/usr/bin/env bash
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)

"$BASE_DIR"/aws/find_by_name.sh "control-plane-us-west-2b.masters.${CLUSTER_NAME}"
