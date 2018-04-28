#!/bin/bash

if [ -z {GCE_ADMIN_ACCESS_CIDR} ]; then
    echo "Missing GCE_ADMIN_ACCESS_CIDR environment variable! Exiting."
    exit 1
fi

gcloud container clusters create matthew-k8s \
--zone us-east1-b \
--disk-size 10 \
--preemptible \
--machine-type f1-micro \
--enable-autorepair \
--enable-autoupgrade \
--enable-master-authorized-networks \
--master-authorized-networks ${GCE_ADMIN_ACCESS_CIDR} \
--enable-autoscaling \
--min-nodes 3 \
--max-nodes 3