#!/bin/bash
set -e

cat << EOF
NOTE: This script assumes the caller has the aws cli setup with
a kops IAM user that has the following access:

AmazonEC2FullAccess
AmazonRoute53FullAccess
AmazonS3FullAccess
IAMFullAccess
AmazonVPCFullAccess

EOF

read -p "Are you sure you've set this up? Type 'y' to proceed: " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting now then. Come back when you're ready!"
    exit 1
fi

if [ -z ${AWS_ACCESS_KEY_ID} ] || \
 [ -z ${AWS_SECRET_ACCESS_KEY} ] || \
 [ -z ${KOPS_CLUSTER_NAME} ] || \
 [ -z ${KOPS_STATE_STORE} ] || \
 [ -z ${KOPS_ADMIN_ACCESS_CIDR} ]; then
    echo "Missing aws environment variables necessary for kops to work! Cannot proceed."
    exit 1
fi

kops create cluster \
--name derp.k8s.local \
--state ${KOPS_STATE_STORE} \
--zones us-east-1a \
--master-size t2.micro \
--master-volume-size 8 \
--node-size t2.micro \
--node-volume-size 8 \
--topology private \
--networking calico \
--admin-access ${KOPS_ADMIN_ACCESS_CIDR} \
--dry-run --output yaml
