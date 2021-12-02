gcloud compute --project=cl-dev-nw-31337 \
firewall-rules create hc-mci \
--direction=INGRESS \
--priority=1000 \
--network=cl-dev-vpc \
--action=ALLOW \
--rules=tcp \
--source-ranges=130.211.0.0/22,35.191.0.0/16 \
--target-tags=gke-dev-cluster-cart-a-552bbf67-node,gke-dev-cluster-cart-b-5b736a2b-node,gke-dev-cluster-cart-c-32576498-node