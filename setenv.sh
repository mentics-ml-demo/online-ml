# This file needs to be sourced so the variables are available in the calling shell.

set -a
source config

BASE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

# isrel() {
#     path=$1
#     [ "$path" = "${path#/}" ] && return
#     false
# }

# if isrel "${ENV_DIR}"; then
#     CONFIG="${BASE_DIR}/${ENV_DIR}"
# else
#     CONFIG="${ENV_DIR}"
# fi

# if isrel "${SECRETS_FILE}"; then
#     SECRETS="${BASE_DIR}/${SECRETS_FILE}"
# else
#     SECRETS="${SECRETS_FILE}"
# fi

ABS_SECRETS_FILE=$(realpath "$SECRETS_FILE")
ABS_ENV_DIR=$(realpath "$ENV_DIR")