#!/bin/bash
set -e

POST_TYPE=$1
PROVIDER=$2
SETTINGS=$3

SLACK_BEST_NEW_MUSIC_WEBHOOK=$(eval "echo \$${PROVIDER}_SLACK_BEST_NEW_MUSIC_WEBHOOK")
if [ -z $SLACK_BEST_NEW_MUSIC_WEBHOOK ]; then
    echo "Missing ${PROVIDER}_SLACK_BEST_NEW_MUSIC_WEBHOOK environment variable! Cannot proceed"
    exit 1
fi

kubectl apply -f k8s/namespace.yaml

scripts_to_populate=("fetch-recent-reviews.py" "filter-already-seen.py" "create-slack-message.py")

if [ "$SETTINGS" = "with_resources" ]; then
    echo "Creating the job resources"
    tmpfile=$(mktemp)
    cp k8s/notify-best-new-music-resources.yaml ${tmpfile}
    for script in "${scripts_to_populate[@]}"; do
        echo "Populating script: ${script}"
        ./insert_script.sh ${tmpfile} "${script}: " ${script} 4 > ${tmpfile}.tmp && mv ${tmpfile}.tmp ${tmpfile}
    done
    ./insert_secret.sh ${tmpfile} WEBHOOK_URL $SLACK_BEST_NEW_MUSIC_WEBHOOK | sed "s/<POST_TYPE>/$POST_TYPE/g" | kubectl apply -f -
    rm ${tmpfile}
fi

echo "Creating the job"
cat k8s/notify-best-new-music.yaml | sed "s/<POST_TYPE>/$POST_TYPE/g" | kubectl apply -f -
