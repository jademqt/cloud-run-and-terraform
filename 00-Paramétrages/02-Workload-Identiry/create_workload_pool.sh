#!/bin/bash
# Pensez à décommenter les lignes [12-15] et [23-30] si la pool et le pool-provider n'existent pas encore.
ID_PROJECT="terraform-test-420413"
GITHUB_REPO_NAME=jademqt/cloud-run-and-terraform
IAM_POOL_NAME=iam-pool-github
IAM_POOL_DISPLAY_NAME=iam-pool-github
IAM_POOL_PROVIDER_NAME=iam-pool-provider-github
IAM_POOL_PROVIDER_DISPLAY_NAME=iam-pool-provider-github

# 1. Création d'une Workload Identity Pool - cela créé une pool dans "IAM & Admin > Workload Identiy Federation" :

#gcloud iam workload-identity-pools create "$IAM_POOL_NAME" \
#  --project=$ID_PROJECT \
#  --location="global" \
#  --display-name="$IAM_POOL_DISPLAY_NAME"

IAM_POOL_ID=$(gcloud iam workload-identity-pools describe "$IAM_POOL_NAME" --project="$ID_PROJECT" --location="global" --format="value(name)")

echo IAM_POOL_ID : $IAM_POOL_ID
# projects/68976813959/locations/global/workloadIdentityPools/iam-pool-github

# 2. Création d'un Workload Identity Provider

#gcloud iam workload-identity-pools providers create-oidc "$IAM_POOL_PROVIDER_NAME" \
#  --project=$ID_PROJECT \
#  --location="global" \
#  --workload-identity-pool="$IAM_POOL_NAME" \
#  --display-name="$IAM_POOL_PROVIDER_DISPLAY_NAME" \
#  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository,attribute.repository_owner=assertion.repository_owner" \
#  --attribute-condition="assertion.repository == '$GITHUB_REPO_NAME'" \
#  --issuer-uri="https://token.actions.githubusercontent.com"


IAM_POOL_PROVIDER_ID=$(gcloud iam workload-identity-pools providers describe "$IAM_POOL_PROVIDER_NAME" --project=$ID_PROJECT --location="global" --workload-identity-pool="$IAM_POOL_NAME" --format="value(name)")

echo IAM_POOL_PROVIDER_ID : $IAM_POOL_PROVIDER_ID
# projects/68976813959/locations/global/workloadIdentityPools/iam-pool-github/providers/iam-pool-provider-github