#!/bin/bash

# Set up Namespace and RBAC for helm
kubectl apply -f helm/rbac.yaml

helm init \
--tiller-namespace helm \
--service-account helm \
--tiller-tls \
--tiller-tls-cert ./tiller.cert.pem \
--tiller-tls-key ./tiller.key.pem \
--tiller-tls-verify \
--tls-ca-cert ca.cert.pem