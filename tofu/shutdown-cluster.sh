#!/bin/bash
set -e
cd out/terraform

tofu destroy -auto-approve -parallelism=100
