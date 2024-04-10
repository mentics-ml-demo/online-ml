#!/bin/bash
set -e

./tofu/99-shutdown-cluster.sh
./kops/99-cleanup.sh