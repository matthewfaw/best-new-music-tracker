# best-new-music-tracker

A simple [k8s](https://kubernetes.io/) CronJob to track the Best New (Album|Track|Reissue) content found on [Pitchfork](https://pitchfork.com/best/).
Content updates are sent as [Slack](https://slack.com/) notifications.

## Entrypoint

In order to deploy the app to your k8s cluster, simply run `./start_best_music_job.sh <POST_TYPE> [with_resources]`, where
**<POST_TYPE>** is:
- `bnm` - for Best new Album
- `bnr` - for Best New Reissue
- `bnt` - for Best New Track

and the (optional) `with_resources` argument specifies whether or not to create the various resources needed by the CronJob.

This script expects that `SLACK_BEST_NEW_MUSIC_WEBHOOK` is a valid environment variable with the webhook URL provided by 
the Incoming Webhook Slack integration
