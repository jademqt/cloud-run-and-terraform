#!/bin/bash

PROJECT_ID=terraform-test-420413
IAM_POOL_ID=projects/68976813959/locations/global/workloadIdentityPools/iam-pool-github
GITHUB_REPO_NAME=jademqt/cloud-run-and-terraform

ROLES=('roles/editor' 'roles/secretmanager.secretAccessor')

for ROLE in "${ROLES[@]}"; do
    gcloud projects add-iam-policy-binding $PROJECT_ID --member="principalSet://iam.googleapis.com/$IAM_POOL_ID/attribute.repository/$GITHUB_REPO_NAME" --role="$ROLE"
done