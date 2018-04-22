#!/bin/bash

echo "Create the kubernetes dashboard"
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
echo "Create an admin user to use the dashboard"
kubectl apply -f dashboard/credentials.yaml

read -p "Would you like to grant the dashboard the cluster-admin role? (Type 'y' to enable): " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "As you wish... The dashboard is now admin..."
    kubectl apply -f dashboard/admin-dashboard.yaml
else
    echo "Skipping granting dashboard admin privileges. This was probably a wise choice, madame."
fi

echo "Set up basic monitoring for the cluster"
kubectl apply -f monitoring/

echo "Start up the music-dealings stuff"
cd music-dealings
categories=("bnm" "bnt" "bnr")
for category in "${categories[@]}"; do
    echo "Creating category $category"
    ./start_best_new_music_job.sh ${category} with_resources
done
