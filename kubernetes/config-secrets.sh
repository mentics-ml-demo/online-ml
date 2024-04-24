#!/usr/bin/env bash
BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")"/..)

# TODO: this is not the ideal way to do this. The scope for difference services' secrets should be managed separately.
# However, the proper way would be to use a service to manage config and secrets which is not in scope for this initial phase of this project.

# TMP_FILE='/tmp/tmp_values.props'
# (envsubst < "${BASE_DIR}/ignore/config/env") > ${TMP_FILE}

kubectl create namespace ml-demo
# kubectl delete -n ml-demo configmap ml-demo-config
kubectl create -n ml-demo configmap ml-demo-config --from-file "${ABS_ENV_DIR}"
# kubectl delete -n ml-demo secret ml-demo-secrets
kubectl create -n ml-demo secret generic ml-demo-secrets --from-env-file "${ABS_SECRETS_FILE}"
