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

echo "Creating Order Async Image"
cd $HOME/multicluster-ingress-gke/app/services/order-async
gcloud builds submit --tag gcr.io/$PROJECT_ID/order-service-async

echo "Creating Customer Async Image"
cd $HOME/multicluster-ingress-gke/app/services/customer-async
gcloud builds submit --tag gcr.io/$PROJECT_ID/customer-service-async

echo "Creating Event Publisher Image"
cd $HOME/multicluster-ingress-gke/app/services/event-publisher
gcloud builds submit --tag gcr.io/$PROJECT_ID/event-publisher