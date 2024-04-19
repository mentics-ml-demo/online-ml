#!/bin/bash

# TODO: if we use the spot option where kops resources are created, delete them here.
echo "Deleting kops resource cluster ${CLUSTER_NAME}"
kops delete cluster --name "${CLUSTER_NAME}" --yes

# Delete the kops state and oidc buckets
delete_bucket() {
    DELETE=$1
    echo "Deleting S3 bucket ${DELETE}"

    # TODO: put if statement around the subcommand to avoid error if it returns nothing
    aws s3api delete-objects --no-cli-pager \
        --bucket "${DELETE}" \
        --delete "$(aws s3api list-object-versions --bucket "${DELETE}" --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

    # TODO: put if statement around the subcommand to avoid error if it returns nothing
    aws s3api delete-objects --no-cli-pager \
        --bucket "${DELETE}" \
        --delete "$(aws s3api list-object-versions --bucket "${DELETE}" --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')"

    aws s3api delete-bucket --no-cli-pager --bucket "${DELETE}"
}

delete_bucket "${STATE_STORE}"
delete_bucket "${OIDC_STORE}"


# cd "$(dirname "${BASH_SOURCE[0]}")"
# rm -rf ../out