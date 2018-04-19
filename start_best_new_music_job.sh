#!/bin/bash
set -e

SETTINGS=$1

if [ -z $SLACK_BEST_NEW_MUSIC_WEBHOOK ]; then
    echo "Missing SLACK_BEST_NEW_MUSIC_WEBHOOK environment variable! Cannot proceed"
    exit 1
fi

scripts_to_populate=("fetch-recent-reviews.py" "filter-already-seen.py" "create-slack-message.py")

if [ "$SETTINGS" = "with_resources" ]; then
    echo "Creating the job resources"
    tmpfile=$(mktemp)
    cp k8s/notify-best-new-music-resources.yaml ${tmpfile}
    for script in "${scripts_to_populate[@]}"; do
        echo "Populating script: ${script}"
        ./insert_script.sh ${tmpfile} "${script}: " ${script} 4 > ${tmpfile}.tmp && mv ${tmpfile}.tmp ${tmpfile}
    done
    ./insert_secret.sh ${tmpfile} WEBHOOK_URL $SLACK_BEST_NEW_MUSIC_WEBHOOK | kubectl apply -f -
    rm ${tmpfile}
fi

echo "Creating the job"
kubectl apply -f k8s/notify-best-new-music.yaml
