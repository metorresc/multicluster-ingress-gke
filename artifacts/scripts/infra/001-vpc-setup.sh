# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Checking if the VPC exists
echo ""
echo "Checking if VPC $VPC_NAME exists"
check_vpc_exists=`gcloud compute networks list --filter "$VPC_NAME" | grep -w "$VPC_NAME" | wc -l | tr -d ' '`
if [ "$check_vpc_exists" = "0" ];then 
  gcloud compute networks create $VPC_NAME \
  --subnet-mode=custom \
  --bgp-routing-mode=REGIONAL
else
  echo "VPC $VPC_NAME already exists. Skipping"
fi
sleep 5

# Checking if the VPC exists
echo ""
echo "Checking if subnet $SUBNET_NAME exists"
check_subnet_exists=`gcloud compute networks subnets list --filter "$SUBNET_NAME" | grep -w "$SUBNET_NAME" | wc -l | tr -d ' '`
if [ "$check_subnet_exists" = "0" ];then 
  gcloud compute networks subnets create $SUBNET_NAME \
  --network=$VPC_NAME \
  --range=$SUBNET_CIDR \
  --region=$REGION
else
  echo "SUBNET $SUBNET_NAME already exists. Skipping"
fi
sleep 5

# Checking if the VPC exists
echo ""
echo "Checking if Secondary Range for PODS $PODS_SECONDARY_RANGE exists"
check_pods_exists=`gcloud compute networks subnets list --filter "$PODS_SECONDARY_RANGE" | grep -w "$PODS_SECONDARY_RANGE" | wc -l | tr -d ' '`
if [ "$check_pods_exists" = "0" ];then 
  gcloud compute networks subnets update $SUBNET_NAME \
  --region=$REGION \
  --add-secondary-ranges $PODS_SECONDARY_RANGE=$PODS_CIDR
else
  echo "Secondary Range for PODS $PODS_SECONDARY_RANGE already exists. Skipping"
fi
sleep 5

# Checking if the VPC exists
echo ""
echo "Checking if Secondary Range for SERVICES $SVCS_SECONDARY_RANGE exists"
check_svcs_exists=`gcloud compute networks subnets list --filter "$SVCS_SECONDARY_RANGE" | grep -w "$SVCS_SECONDARY_RANGE" | wc -l | tr -d ' '`
if [ "$check_svcs_exists" = "0" ];then 
  gcloud compute networks subnets update $SUBNET_NAME \
  --region=$REGION \
  --add-secondary-ranges $SVCS_SECONDARY_RANGE=$SVCS_CIDR
else
  echo "Secondary Range for Services $SVCS_SECONDARY_RANGE already exists. Skipping"
fi
sleep 5

# Checking if the Router exists
echo ""
echo "Checking if a Cloud Router exists for this Network and Region"
check_rtr_exists=`gcloud compute routers list --filter "router-$REGION" | grep -w "router-$REGION" | wc -l | tr -d ' '`
if [ "$check_rtr_exists" = "0" ];then 
  gcloud compute routers create router-$REGION \
  --project=$PROJECT_ID \
  --network=$VPC_NAME \
  --asn=$ASN_NUMBER \
  --region=$REGION
else
  echo "Cloud Router exists. Skipping"
fi
sleep 5

# Checking if the NAT exists
echo ""
echo "Checking if a Cloud NAT exists for this Network and Region"
check_nat_exists=`gcloud compute routers list --filter "router-$REGION" | grep -w "router-$REGION" | wc -l | tr -d ' '`
if [ "$check_nat_exists" = "0" ];then 
  gcloud compute routers nats create nat-$REGION \
  --router=router-$REGION \
  --auto-allocate-nat-external-ips \
  --nat-all-subnet-ip-ranges \
  --enable-logging
else
  echo "Cloud NAT exists. Skipping"
fi
sleep 5

gcloud compute networks create cl-core-vpc \
--project=cl-core-nw-31337 \
--subnet-mode=custom \
--mtu=1460 \
--bgp-routing-mode=global

gcloud compute networks subnets create cl-core-subnet-us-east4-hub \
--project=cl-core-nw-31337 \
--range=192.168.116.0/24 \
--network=cl-core-vpc \
--region=us-east4 \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create cl-core-subnet-us-west2-hub \
--project=cl-core-nw-31337 \
--range=192.168.117.0/24 \
--network=cl-core-vpc \
--region=us-west2 \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create cl-core-subnet-southamerica-west1-hub \
--project=cl-core-nw-31337 \
--range=192.168.119.0/24 \
--network=cl-core-vpc \
--region=southamerica-west1 \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute routers create cl-core-rtr-us-east4 \
--project=cl-core-nw-31337 \
--network=cl-core-vpc \
--asn=4200031337 \
--region=us-east4

gcloud compute routers create cl-core-rtr-us-west2 \
--project=cl-core-nw-31337 \
--network=cl-core-vpc \
--asn=4200031338 \
--region=us-west2

gcloud compute routers create cl-core-rtr-southamerica-west1 \
--project=cl-core-nw-31337 \
--network=cl-core-vpc \
--asn=4200031339 \
--region=southamerica-west1

gcloud compute routers nats create cl-core-nat-us-east4 \
--project=cl-core-nw-31337 \
--router=cl-core-rtr-us-east4 \
--router-region=us-east4 \
--auto-allocate-nat-external-ips \
--nat-all-subnet-ip-ranges \
--enable-logging

gcloud compute routers nats create cl-core-nat-us-west2 \
--project=cl-core-nw-31337 \
--router=cl-core-rtr-us-west2 \
--router-region=us-west2 \
--auto-allocate-nat-external-ips \
--nat-all-subnet-ip-ranges \
--enable-logging

gcloud compute routers nats create cl-core-nat-southamerica-west1 \
--project=cl-core-nw-31337 \
--router=cl-core-rtr-southamerica-west1 \
--router-region=southamerica-west1 \
--auto-allocate-nat-external-ips \
--nat-all-subnet-ip-ranges \
--enable-logging

gcloud compute networks peerings create cl-peering-core-to-dev \
--project=cl-core-nw-31337 \
--network=cl-core-vpc \
--peer-project cl-dev-nw-31337 \
--peer-network cl-dev-vpc

gcloud compute networks peerings create cl-peering-dev-to-core \
--project=cl-dev-nw-31337 \
--network=cl-dev-vpc \
--peer-project cl-core-nw-31337 \
--peer-network cl-core-vpc

gcloud compute networks create cl-qa-vpc \
--project=cl-qa-nw-31337 \
--subnet-mode=custom \
--mtu=1460 \
--bgp-routing-mode=regional

gcloud compute networks subnets create cl-qa-subnet-us-east4-hub \
--project=cl-qa-nw-31337 \
--range=192.168.116.0/24 \
--network=cl-qa-vpc \
--region=us-east4 \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create cl-qa-subnet-us-west2-hub \
--project=cl-qa-nw-31337 \
--range=192.168.117.0/24 \
--network=cl-qa-vpc \
--region=us-west2 \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all

gcloud compute networks subnets create cl-qa-subnet-southamerica-west1-hub \
--project=cl-qa-nw-31337 \
--range=192.168.119.0/24 \
--network=cl-qa-vpc \
--region=southamerica-west1 \
--enable-private-ip-google-access \
--enable-flow-logs \
--logging-aggregation-interval=interval-5-sec \
--logging-flow-sampling=0.5 \
--logging-metadata=include-all