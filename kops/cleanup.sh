#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"

# TODO: if we use the spot option where kops resources are created, delete them here.
# kops delete cluster --name ${CLUSTER_NAME} --yes

# Delete the kops state and oidc buckets
delete_bucket() {
    DELETE=$1
    aws s3api delete-objects \
        --bucket ${DELETE} \
        --delete "$(aws s3api list-object-versions --bucket ${DELETE} --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')"

    aws s3api delete-objects \
        --bucket ${DELETE} \
        --delete "$(aws s3api list-object-versions --bucket ${DELETE} --query='{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}')"

    aws s3api delete-bucket --bucket ${DELETE}
}

# delete_bucket ${STATE_STORE}
delete_bucket ${OIDC_STORE}
