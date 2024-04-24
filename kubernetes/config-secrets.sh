#!/usr/bin/env bash
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)

# TODO: this is not the ideal way to do this. The scope for difference services' secrets should be managed separately.
# However, the proper way would be to use a service to manage config and secrets which is not in scope for this initial phase of this project.

# TMP_FILE='/tmp/tmp_values.props'
# (envsubst < "${BASE_DIR}/ignore/config/env") > ${TMP_FILE}

isrel() {
    path=$1
    [ "$path" = "${path#/}" ] && return
    false
}

if isrel "${ENV_DIR}"; then
    CONFIG="${BASE_DIR}/${ENV_DIR}"
else
    CONFIG="${ENV_DIR}"
fi

if isrel "${SECRETS_FILE}"; then
    SECRETS="${BASE_DIR}/${SECRETS_FILE}"
else
    SECRETS="${SECRETS_FILE}"
fi

kubectl create configmap ml-demo-config --from-file "${CONFIG}"
kubectl create secret ml-demo-secrets --from-env-file "${SECRETS}"
