#!/bin/bash
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)
"$BASE_DIR/aws/connect.sh" "redpanda" ec2-user 8020 8080
