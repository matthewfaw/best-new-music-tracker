latest_line=$(cat /out/filter-already-seen.out | sort -k5,5 -t "$DELIMITER" | tail -n 1)
echo "The latest line is: $latest_line"
now=$(date -u +"%Y-%m-%dT%H_%M_%S.000Z")
if [ ! -z "$latest_line" ]; then
  last_seen_date=$(echo $latest_line | cut -d "$DELIMITER" -f 5)
  echo "Setting new last post date to: $last_seen_date"
  last_seen_posts=$(grep "$last_seen_date" /out/filter-already-seen.out | cut -d "$DELIMITER" -f 1 | grep -o ".*" | tr '\n' "$DELIMITER" | sed "s/${DELIMITER}\$//g")
  echo "Setting new last seen posts to: $last_seen_posts"

  kubectl create cm last-seen-${POST_TYPE} --from-literal LAST_SEEN_DATE="$last_seen_date" --from-literal LAST_SEEN_POSTS="$last_seen_posts" --dry-run -o yaml | kubectl apply -f -
  kubectl label cm last-seen-${POST_TYPE} --overwrite last_post=${now}
else
  echo "Determined the latest line to be empty! Doing nothing"
fi
echo "Setting last check: $now"
kubectl label cm last-seen-${POST_TYPE} --overwrite last_check=${now}

printf '=%.0s' `seq 1 100` | xargs

for file in /out/*; do
  echo "Printing contents of file: ${file}"
  printf '=%.0s' `seq 1 100` | xargs
  cat ${file}
  printf '=%.0s' `seq 1 100` | xargs
done
