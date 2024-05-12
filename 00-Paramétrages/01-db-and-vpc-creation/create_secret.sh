#!/bin/bash

project_id="terraform-test-420413"

secret_id="DB_PASS"
secret_value="cloudrun-user-pwd"

# Création du secret
gcloud secrets create $secret_id --replication-policy automatic --project $project_id

# Ajout de la valeur au secret
echo -n $secret_value | gcloud secrets versions add $secret_id --data-file=-
