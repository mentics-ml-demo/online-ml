#!/bin/bash

# Abort early if any script fails
set -e

# Make paths based on location of this script
# parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
# pushd ${parent_path} > /dev/null
cd "$(dirname "${BASH_SOURCE[0]}")"

# echo "State store: ${STATE_STORE}"
# echo "OIDC store: ${OIDC_STORE}"
aws s3api create-bucket \
    --bucket ${STATE_STORE} \
    --region us-east-1

aws s3api put-bucket-versioning --bucket ${STATE_STORE} --versioning-configuration Status=Enabled

aws s3api create-bucket \
    --bucket ${OIDC_STORE} \
    --region us-east-1 \
    --object-ownership BucketOwnerPreferred
aws s3api put-public-access-block \
    --bucket ${OIDC_STORE} \
    --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-acl \
    --bucket ${OIDC_STORE} \
    --acl public-read
