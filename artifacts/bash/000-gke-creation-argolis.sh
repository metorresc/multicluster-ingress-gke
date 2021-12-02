#  Copyright 2021 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

gcloud beta container --project "cl-dev-commerce-cart" \
clusters create "dev-cluster-cart-a" \
--zone "us-east4-a" \
--no-enable-basic-auth \
--cluster-version "1.21.5-gke.1302" \
--release-channel "regular" \
--machine-type "e2-standard-8" \
--image-type "COS" \
--disk-type "pd-ssd" \
--disk-size "100" \
--boot-disk-kms-key "projects/cl-dev-commerce-cart/locations/us-east4/keyRings/cl-dev-commerce-cart-keyring-us-east4/cryptoKeys/cl-dev-commerce-cart-key-us-east4" \
--metadata disable-legacy-endpoints=true \
--service-account "cl-dev-commerce-cart-gke-svc-a@cl-dev-commerce-cart.iam.gserviceaccount.com" \
--max-pods-per-node "110" \
--preemptible --num-nodes "2" \
--logging=SYSTEM,WORKLOAD \
--monitoring=SYSTEM \
--enable-private-nodes \
--enable-private-endpoint \
--master-ipv4-cidr "172.16.2.16/28" \
--enable-master-global-access \
--enable-ip-alias \
--network "projects/cl-dev-nw-31337/global/networks/cl-dev-vpc" \
--subnetwork "projects/cl-dev-nw-31337/regions/us-east4/subnetworks/cl-dev-subnet-us-east4-nodes" \
--cluster-secondary-range-name "cl-dev-subnet-us-east4-pods" \
--services-secondary-range-name "cl-dev-subnet-us-east4-svcs" \
--enable-intra-node-visibility --default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "0" \
--max-nodes "3" \
--enable-network-policy \
--enable-master-authorized-networks \
--master-authorized-networks 172.20.0.13/32 \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,NodeLocalDNS,ApplicationManager,GcePersistentDiskCsiDriver \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--enable-autoprovisioning \
--min-cpu 2 \
--max-cpu 8 \
--min-memory 8 \
--max-memory 32 \
--autoprovisioning-service-account=cl-dev-commerce-cart-gke-svc-a@cl-dev-commerce-cart.iam.gserviceaccount.com \
--enable-autoprovisioning-autorepair \
--enable-autoprovisioning-autoupgrade \
--autoprovisioning-max-surge-upgrade 1 \
--autoprovisioning-max-unavailable-upgrade 0 \
--autoscaling-profile optimize-utilization \
--database-encryption-key "projects/cl-dev-commerce-cart/locations/us-east4/keyRings/cl-dev-commerce-cart-keyring-us-east4/cryptoKeys/cl-dev-commerce-cart-key-us-east4" \
--enable-vertical-pod-autoscaling \
--workload-pool "cl-dev-commerce-cart.svc.id.goog" \
--enable-shielded-nodes \
--shielded-secure-boot \
--shielded-integrity-monitoring \
--disable-default-snat \
--node-locations "us-east4-a"

gcloud beta container --project "cl-dev-commerce-cart" \
clusters create "dev-cluster-cart-b" \
--zone "us-west2-b" \
--no-enable-basic-auth \
--cluster-version "1.21.5-gke.1302" \
--release-channel "regular" \
--machine-type "e2-standard-8" \
--image-type "COS" \
--disk-type "pd-ssd" \
--disk-size "100" \
--boot-disk-kms-key "projects/cl-dev-commerce-cart/locations/us-west2/keyRings/cl-dev-commerce-cart-keyring-us-west2/cryptoKeys/cl-dev-commerce-cart-key-us-west2" \
--metadata disable-legacy-endpoints=true \
--service-account "cl-dev-commerce-cart-gke-svc-b@cl-dev-commerce-cart.iam.gserviceaccount.com" \
--max-pods-per-node "110" \
--preemptible --num-nodes "2" \
--logging=SYSTEM,WORKLOAD \
--monitoring=SYSTEM \
--enable-private-nodes \
--enable-private-endpoint \
--master-ipv4-cidr "172.17.2.16/28" \
--enable-master-global-access \
--enable-ip-alias \
--network "projects/cl-dev-nw-31337/global/networks/cl-dev-vpc" \
--subnetwork "projects/cl-dev-nw-31337/regions/us-west2/subnetworks/cl-dev-subnet-us-west2-nodes" \
--cluster-secondary-range-name "cl-dev-subnet-us-west2-pods" \
--services-secondary-range-name "cl-dev-subnet-us-west2-svcs" \
--enable-intra-node-visibility --default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "0" \
--max-nodes "3" \
--enable-network-policy \
--enable-master-authorized-networks \
--master-authorized-networks 172.20.0.13/32 \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,NodeLocalDNS,ApplicationManager,GcePersistentDiskCsiDriver \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--enable-autoprovisioning \
--min-cpu 2 \
--max-cpu 8 \
--min-memory 8 \
--max-memory 32 \
--autoprovisioning-service-account=cl-dev-commerce-cart-gke-svc-b@cl-dev-commerce-cart.iam.gserviceaccount.com \
--enable-autoprovisioning-autorepair \
--enable-autoprovisioning-autoupgrade \
--autoprovisioning-max-surge-upgrade 1 \
--autoprovisioning-max-unavailable-upgrade 0 \
--autoscaling-profile optimize-utilization \
--database-encryption-key "projects/cl-dev-commerce-cart/locations/us-west2/keyRings/cl-dev-commerce-cart-keyring-us-west2/cryptoKeys/cl-dev-commerce-cart-key-us-west2" \
--enable-vertical-pod-autoscaling \
--workload-pool "cl-dev-commerce-cart.svc.id.goog" \
--enable-shielded-nodes \
--shielded-secure-boot \
--shielded-integrity-monitoring \
--disable-default-snat \
--node-locations "us-west2-b"

gcloud beta container --project "cl-dev-commerce-cart" \
clusters create "dev-cluster-cart-c" \
--zone "southamerica-west1-c" \
--no-enable-basic-auth \
--cluster-version "1.21.5-gke.1302" \
--release-channel "regular" \
--machine-type "e2-standard-8" \
--image-type "COS" \
--disk-type "pd-ssd" \
--disk-size "100" \
--boot-disk-kms-key "projects/cl-dev-commerce-cart/locations/southamerica-west1/keyRings/cl-dev-commerce-cart-keyring-sa-west1/cryptoKeys/cl-dev-commerce-cart-key-sa-west1" \
--metadata disable-legacy-endpoints=true \
--service-account "cl-dev-commerce-cart-gke-svc-c@cl-dev-commerce-cart.iam.gserviceaccount.com" \
--max-pods-per-node "110" \
--preemptible --num-nodes "2" \
--logging=SYSTEM,WORKLOAD \
--monitoring=SYSTEM \
--enable-private-nodes \
--enable-private-endpoint \
--master-ipv4-cidr "172.19.2.16/28" \
--enable-master-global-access \
--enable-ip-alias \
--network "projects/cl-dev-nw-31337/global/networks/cl-dev-vpc" \
--subnetwork "projects/cl-dev-nw-31337/regions/southamerica-west1/subnetworks/cl-dev-subnet-southamerica-west1-nodes" \
--cluster-secondary-range-name "cl-dev-subnet-southamerica-west1-pods" \
--services-secondary-range-name "cl-dev-subnet-southamerica-west1-svcs" \
--enable-intra-node-visibility --default-max-pods-per-node "110" \
--enable-autoscaling \
--min-nodes "0" \
--max-nodes "3" \
--enable-network-policy \
--enable-master-authorized-networks \
--master-authorized-networks 172.20.0.13/32 \
--addons HorizontalPodAutoscaling,HttpLoadBalancing,NodeLocalDNS,ApplicationManager,GcePersistentDiskCsiDriver \
--enable-autoupgrade \
--enable-autorepair \
--max-surge-upgrade 1 \
--max-unavailable-upgrade 0 \
--enable-autoprovisioning \
--min-cpu 2 \
--max-cpu 8 \
--min-memory 8 \
--max-memory 32 \
--autoprovisioning-service-account=cl-dev-commerce-cart-gke-svc-c@cl-dev-commerce-cart.iam.gserviceaccount.com \
--enable-autoprovisioning-autorepair \
--enable-autoprovisioning-autoupgrade \
--autoprovisioning-max-surge-upgrade 1 \
--autoprovisioning-max-unavailable-upgrade 0 \
--autoscaling-profile optimize-utilization \
--database-encryption-key "projects/cl-dev-commerce-cart/locations/southamerica-west1/keyRings/cl-dev-commerce-cart-keyring-sa-west1/cryptoKeys/cl-dev-commerce-cart-key-sa-west1" \
--enable-vertical-pod-autoscaling \
--workload-pool "cl-dev-commerce-cart.svc.id.goog" \
--enable-shielded-nodes \
--shielded-secure-boot \
--shielded-integrity-monitoring \
--disable-default-snat \
--node-locations "southamerica-west1-c"
