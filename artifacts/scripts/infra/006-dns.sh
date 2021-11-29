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

gcloud beta dns --project=cl-core-nw-31337 managed-zones create cl-hogwarts-arpa \
--description="Base Domain for Chile" \
--dns-name="cl.hogwarts.arpa." \
--visibility="private"

gcloud beta dns --project=cl-dev-nw-31337 managed-zones create dev-cl-hogwarts-arpa \
--description="Dev Domain for Chile" \
--dns-name="dev.cl.hogwarts.arpa." \
--visibility="private" \
--networks="cl-dev-vpc"

gcloud beta dns managed-zones create dev-cl-hogwarts-arpa \
--project=cl-core-nw-31337 \
--description="DNS Peering Zone" \
--dns-name="dev.cl.hogwarts.arpa." \
--visibility="private" \
--networks="cl-core-vpc" \
--target-project="cl-dev-nw-31337" \
--target-network="cl-dev-vpc"

gcloud beta dns managed-zones create dev-cl-hogwarts-arpa \
--project=cl-core-nw-31337 \
--description="DNS Peering Zone" \
--dns-name="dev.cl.hogwarts.arpa." \
--visibility="private" \
--networks="cl-core-vpc" \
--target-project="cl-dev-nw-31337" \
--target-network="cl-dev-vpc"

gcloud beta dns policies create dev-cl-hogwarts-arpa \
--project=cl-dev-nw-31337 \
--description="DEV DNS Server Policy" \
--enable-inbound-forwarding \
--enable-logging
