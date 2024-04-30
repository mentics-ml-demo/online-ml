#!/usr/bin/env bash
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)

# TODO: this is not the ideal way to do this. The scope for difference services' secrets should be managed separately.
# However, the proper way would be to use a service to manage config and secrets which is not in scope for this initial phase of this project.

# TMP_FILE='/tmp/tmp_values.props'
# (envsubst < "${BASE_DIR}/ignore/config/env") > ${TMP_FILE}

kubectl create namespace online-ml
# kubectl delete -n online-ml configmap online-ml-config
kubectl create -n online-ml configmap online-ml-config --from-file "${ABS_ENV_DIR}"
# kubectl delete -n online-ml secret online-ml-secrets
kubectl create -n online-ml secret generic online-ml-secrets --from-env-file "${ABS_SECRETS_FILE}"
