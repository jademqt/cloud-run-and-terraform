INSTANCE_NAME="mysql-air-quality"
NUMBER_CPUS=2
MEMORY_SIZE="8Gi"
REGION="europe-west9"
ZONE="europe-west9-a"
NETWORK="vpc-air-quality"
STORAGE="10GB"
AUTH_NETWORK="89.84.216.134/32"
RESERVED_RANGE_NAME="google-managed-services-vpc"
RESERVED_RANGE="172.30.0.0"
DATABASE_NAME="measurements"
DYNAMIC_ROUTING_MODE="global"
MYSQL_CR_USER="cloudrun-user"
MYSQL_CR_PWD="cloudrun-user-pwd"
MYSQL_ROOT_PWD="root-pwd"

gcloud compute networks create $NETWORK \
    --subnet-mode=auto \
    --bgp-routing-mode=$DYNAMIC_ROUTING_MODE \
    --subnet-mode=custom \
    --enable-ula-internal-ipv6 \
    --mtu=1460 \
    --network-firewall-policy-enforcement-order=AFTER_CLASSIC_FIREWALL  \
    --description="Network so that the various services communicate via their private address."

gcloud compute addresses create $RESERVED_RANGE_NAME \
   --global \
   --purpose=VPC_PEERING \
   --addresses=$RESERVED_RANGE \
   --prefix-length=16 \
   --network=$NETWORK

gcloud services vpc-peerings connect \
   --service=servicenetworking.googleapis.com \
   --ranges=$RESERVED_RANGE_NAME \
   --network=$NETWORK

gcloud beta sql instances create $INSTANCE_NAME \
 --database-version="MYSQL_8_0" \
 --cpu=$NUMBER_CPUS \
 --memory=$MEMORY_SIZE \
 --zone=$ZONE \
 --enable-google-private-path \
 --storage-size=$STORAGE \
 --authorized-networks=$AUTH_NETWORK \
 --network=$NETWORK \
 --allocated-ip-range-name=$RESERVED_RANGE_NAME \
 --storage-type=SSD \
 --root-password=$MYSQL_ROOT_PWD

gcloud sql databases create $DATABASE_NAME \
 --instance=$INSTANCE_NAME 

gcloud sql users create $MYSQL_CR_USER --instance=$INSTANCE_NAME --password=$MYSQL_CR_PWD
