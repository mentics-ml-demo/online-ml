#!/usr/bin/env bash
NAME=$1

BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)

"$BASE_DIR"/aws/find_instance.sh "Tags[].Value" "$NAME"
