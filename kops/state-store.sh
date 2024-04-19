#!/bin/bash

# Abort early if any script fails
set -e

# Make paths based on location of this script
cd "$(dirname "${BASH_SOURCE[0]}")"


echo "Creating state store in S3: ${STATE_STORE_URL}"

aws s3api create-bucket --no-cli-pager \
    --bucket "${STATE_STORE}" \
    --region us-east-1
aws s3api put-bucket-versioning --no-cli-pager --bucket "${STATE_STORE}" --versioning-configuration Status=Enabled


echo "Creating OIDC store in S3: ${OIDC_STORE_URL}"

aws s3api create-bucket --no-cli-pager \
    --bucket "${OIDC_STORE}" \
    --region us-east-1 \
    --object-ownership BucketOwnerPreferred
aws s3api put-public-access-block --no-cli-pager \
    --bucket "${OIDC_STORE}" \
    --public-access-block-configuration BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false
aws s3api put-bucket-acl --no-cli-pager \
    --bucket "${OIDC_STORE}" \
    --acl public-read
