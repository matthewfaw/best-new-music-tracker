#!/bin/bash

PROVIDER=$1 #KOPS, GCE

if [ "$PROVIDER" = "KOPS" ]; then
    echo "Using kops, so need to install dashboard"
    echo "Create the kubernetes dashboard"
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
fi

read -p "Would you like to set up a user? (Type 'y' to enable): " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ "$PROVIDER" = "KOPS" ]; then
        echo "Creating a user useful to kops"
        echo "Create an admin user to use the dashboard"
        kubectl apply -f dashboard/credentials.yaml
    elif [ "$PROVIDER" = "GCE" ]; then
        echo "Setting up user permissions useful in GKE"
        sed "s/<USER>/${GCE_USER}/g" admin/admin.yaml | kubectl apply -f -
    else
        echo "Did not recognize $PROVIDER... Not setting up a user"
    fi
else
    echo "Not creating the service account"
fi

read -p "Would you like to grant the dashboard the cluster-admin role? (Type 'y' to enable): " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "As you wish... The dashboard is now admin..."
    kubectl apply -f dashboard/admin-dashboard.yaml
else
    echo "Skipping granting dashboard admin privileges. This was probably a wise choice, madame."
fi

read -p "Would you like to set up monitoring? (Type 'y' to enable): " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Set up basic monitoring for the cluster"
    kubectl apply -f monitoring/
else
    echo "Not creating monitoring"
fi

echo "Start up the music-dealings stuff"
cd music-dealings
categories=("bnm" "bnt" "bnr")
for category in "${categories[@]}"; do
    echo "Creating category $category"
    ./start_best_new_music_job.sh ${category} ${PROVIDER} with_resources
done
