#!/usr/bin/env bash
KEY=$1
VALUE=$2

echo -n "$VALUE" > "$ABS_ENV_DIR/$KEY"
