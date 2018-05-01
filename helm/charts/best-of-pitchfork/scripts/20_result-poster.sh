echo "Posting the following message to slack:"
cat /out/create-slack-message.out | jq '.'
if [ $(cat /out/create-slack-message.out | jq '.attachments[]' | wc -l) = 0 ]; then
  echo "Slack message is empty! Skipping post"
  exit 0
fi
curl -X POST -d "$(cat /out/create-slack-message.out)" $SLACK_BEST_NEW_MUSIC_WEBHOOK
