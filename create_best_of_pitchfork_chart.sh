#!/bin/bash

WEBHOOK_URL=$1
RELEASE_NAME=$2
NAMESPACE=$3

helm install \
--tls \
--set webhookUrl="$WEBHOOK_URL" \
--name "$RELEASE_NAME" \
--namespace "$NAMESPACE" \
./helm/charts/best-of-pitchfork
