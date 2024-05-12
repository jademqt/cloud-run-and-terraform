#!/bin/bash

IMPORT_TO_TF_PB_DETECTED=0  
PROJECT_ID=terraform-test-420413
VPC="vpc-air-quality"
IP_RANGE_NAME="google-managed-services-vpc"
CONNECTOR_NAME="servicenetworking.googleapis.com"
MYSQL_NAME="mysql-air-quality"

#######################################
##        IMPORTER LES SECRETS       ##
#######################################
DB_PASS="DB_PASS"

# Ressource : google_secret_manager_secret.mysql_user_password
if terraform state show "module.cloud_run.google_secret_manager_secret.mysql_user_password"; then
    echo "=> The secret $DB_PASS is already managed by Terraform, skipping import."
else
    terraform import "module.cloud_run.google_secret_manager_secret.mysql_user_password" "projects/$PROJECT_ID/secrets/$DB_PASS" 
    if [ $? -eq 1 ]; then
        TF_ERROR=$(terraform 2>&1)
        echo "=> The secret $DB_PASS couldn't be imported to the Terraform configuration."
        ((IMPORT_TO_TF_PB_DETECTED++))
    fi
fi

###################################
##        IMPORTER LE VPC        ##
###################################
if terraform state show "module.network.google_compute_network.vpc"; then
    echo "=> The vpc is already managed by Terraform, skipping import."
else
    terraform import "module.network.google_compute_network.vpc" "projects/$PROJECT_ID/global/networks/$VPC"
    if [ $? -eq 1 ]; then
        TF_ERROR=$(terraform 2>&1)
        echo "=> The vpc couldn't be imported to the Terraform configuration."
        ((IMPORT_TO_TF_PB_DETECTED++))
    fi
fi

#########################################################
##        IMPORTER LE CONNECTEUR ET LE RANGE IP        ##
#########################################################
if terraform state show "module.network.google_compute_global_address.global_internal_address_vpc"; then
    echo "=> The IP range is already managed by Terraform, skipping import."
else
    terraform import "module.network.google_compute_global_address.global_internal_address_vpc" $PROJECT_ID/$IP_RANGE_NAME
    if [ $? -eq 1 ]; then
        TF_ERROR=$(terraform 2>&1)
        echo "=> The IP range couldn't be imported to the Terraform configuration."
        ((IMPORT_TO_TF_PB_DETECTED++))
    fi
fi


if terraform state show "module.network.google_service_networking_connection.service-private-access"; then
    echo "=> The service private access is already managed by Terraform, skipping import."
else
    terraform import "module.network.google_service_networking_connection.service-private-access" "/projects/$PROJECT_ID/global/networks/$VPC:$CONNECTOR_NAME"
    if [ $? -eq 1 ]; then
        TF_ERROR=$(terraform 2>&1)
        echo "=> The vpc couldn't be imported to the Terraform configuration."
        ((IMPORT_TO_TF_PB_DETECTED++))
    fi
fi

############################################
##        IMPORTER LA BASE MYSQL        ##
############################################
if terraform state show "module.database.google_sql_database_instance.mysql"; then
    echo "=> The MySQL database is already managed by Terraform, skipping import."
else
    terraform import "module.database.google_sql_database_instance.mysql" "/projects/$PROJECT_ID/instances/$MYSQL_NAME"
    if [ $? -eq 1 ]; then
        TF_ERROR=$(terraform 2>&1)
        echo "=> The MySQL instance couldn't be imported to the Terraform configuration."
        ((IMPORT_TO_TF_PB_DETECTED++))
    fi
fi

#############################
##        CONCLUSION       ##
#############################

# Affichage du nombre de soucis
if [ $IMPORT_TO_TF_PB_DETECTED -gt 0 ]; then
    echo ""
    echo "=> $IMPORT_TO_TF_PB_DETECTED ressource couldn't be imported. Exit."
    echo ""
    exit 1
fi