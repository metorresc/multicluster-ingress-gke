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

echo ""
echo "Creating Anthos Workstation on region $REGION since this is a private cluster"
gcloud compute instances create $ANTHOS_WS \
--image-family=ubuntu-2004-lts --image-project=ubuntu-os-cloud \
--zone=$ZONE \
--boot-disk-size 100G \
--boot-disk-type pd-standard \
--network $VPC_NAME
--subnet $SUBNET_NAME \
--no-address \
--tags $CLUSTER_ID \
--service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
--scopes cloud-platform \
--machine-type $MACHINE_TYPE || :
sleep 5

echo ""
echo "Creating GKE Cluster on region $REGION"
gcloud beta container --project $PROJECT_ID \
clusters create $CLUSTER_ID \
--zone $ZONE \
--no-enable-basic-auth \
--tags $CLUSTER_ID \
--release-channel "regular" \
--machine-type $MACHINE_TYPE \
--image-type "COS_CONTAINERD" \
--disk-type pd-standard \
--disk-size 100G \
--metadata disable-legacy-endpoints=true \
--service-account $SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
--max-pods-per-node "110" \
--preemptible \
--num-nodes "3" \
--enable-stackdriver-kubernetes \
--enable-private-nodes \
--enable-private-endpoint \
--master-ipv4-cidr $MNODE_IPV4 \
--enable-ip-alias \
--network $VPC_NAME \
--subnetwork $SUBNET_NAME \
--cluster-secondary-range-name $PODS_SECONDARY_RANGE \
--services-secondary-range-name $SVCS_SECONDARY_RANGE \
--enable-intra-node-visibility \
--default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "0" \
--max-nodes "6" \
--enable-master-authorized-networks \
--master-authorized-networks $SUBNET_CIDR \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,NodeLocalDNS,ApplicationManager,GcePersistentDiskCsiDriver,ConfigConnector \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--enable-autoprovisioning \
--min-cpu 1 \
--max-cpu 8 \
--min-memory 1 \
--max-memory 32 \
--autoprovisioning-service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
--enable-autoprovisioning-autorepair \
--enable-autoprovisioning-autoupgrade \
--autoprovisioning-max-surge-upgrade 1 \
--autoprovisioning-max-unavailable-upgrade 0 \
--enable-vertical-pod-autoscaling \
--enable-shielded-nodes \
--shielded-secure-boot \
--enable-l4-ilb-subsetting \
--workload-pool $PROJECT_ID.svc.id.goog \
--node-locations $ZONE || :
sleep 5

echo ""
echo "Testing if the VMs were created correctly"
gcloud compute instances list
sleep 5

echo ""
echo " Creating Firewall Rules for IAP and Anthos"
gcloud compute --project=$PROJECT_ID firewall-rules create $CLUSTER_ID-ingress-from-iap --direction=INGRESS --network=$VPC_NAME --action=ALLOW --source-ranges=35.235.240.0/20 --target-tags=$CLUSTER_ID --rules=tcp:22 || :
gcloud compute --project=$PROJECT_ID firewall-rules create $CLUSTER_ID-ingress-asm-acm-ports --direction=INGRESS --network=$VPC_NAME --action=ALLOW --source-tags=$CLUSTER_ID --target-tags=$CLUSTER_ID --rules=tcp:10250,tcp:443,tcp:8443,tcp:8676,tcp:15017 || :
sleep 5

echo ""
echo "=========================="
echo " VMs deployment completed "
echo "=========================="