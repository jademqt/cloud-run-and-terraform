#!/bin/bash
PROJECT_ID="terraform-test-420413"

services=(
    "cloudresourcemanager.googleapis.com"
    "secretmanager.googleapis.com"
    "iam.googleapis.com"
    "compute.googleapis.com"
    "sqladmin.googleapis.com"
    "run.googleapis.com"
    "serviceusage.googleapis.com"
    "servicenetworking.googleapis.com"
    "vpcaccess.googleapis.com"
)
for service in "${services[@]}"; do
    gcloud services enable "$service" --project=$PROJECT_ID        
done