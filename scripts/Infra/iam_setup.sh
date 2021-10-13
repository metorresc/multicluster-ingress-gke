#!/bin/bash
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
source ./variables.env
set -eu

echo ""
echo "Preparing to execute with the following values:"
echo "==================================================="
echo "Project ID: $PROJECT_ID"
echo "Service Account Name: $SERVICE_ACCOUNT"
echo "==================================================="
echo ""
echo "Continuing in 5 seconds. Ctrl+C to cancel"
sleep 5

check_svc_acct=`gcloud iam service-accounts list --filter "$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" | grep "$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" | wc -l | tr -d ' '`
if [ "$check_svc_acct" = "0" ];then 
  gcloud iam service-accounts create $SERVICE_ACCOUNT
else
  echo "Service Account $SERVICE_ACCOUNT already exists. Skipping"
fi
sleep 5

# Enable the required APIs
echo ""
echo "Enabling Required APIs"
gcloud services enable \
    anthos.googleapis.com \
    anthosgke.googleapis.com \
    cloudresourcemanager.googleapis.com \
    container.googleapis.com \
    gkeconnect.googleapis.com \
    gkehub.googleapis.com \
    serviceusage.googleapis.com \
    stackdriver.googleapis.com \
    monitoring.googleapis.com \
    logging.googleapis.com
sleep 5

# Binding permissions to the service account
echo ""
echo "Configuring privileges to service account"
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role=roles/gkehub.connect \
  --role=roles/gkehub.admin \
  --role=roles/logging.logWriter \
  --role=roles/monitoring.metricWriter \
  --role=roles/monitoring.dashboardEditor \
  --role=roles/stackdriver.resourceMetadata.writer \
  --role=roles/iam.serviceAccountKeyAdmin \
  --role=roles/iam.serviceAccountAdmin \
  --role=roles/resourcemanager.projectIamAdmin \
  --role=roles/container.admin
sleep 5


# echo "Creating K8s Service Account"
# kubectl create clusterrolebinding k8s-svc-account-admin --clusterrole cluster-admin --user $K8S_SERVICE_ACCOUNT