import sys

original_file = sys.argv[1]
delimiter = sys.argv[2]
latest_seen_post_date = sys.argv[3]
latest_seen_post_titles = sys.argv[4]

with open(original_file) as f:
    for line in f:
        split = line.split(delimiter)
        title = split[0]
        post_date = split[4]

        if post_date > latest_seen_post_date or (post_date == latest_seen_post_date and title not in latest_seen_post_titles.split(delimiter)):
            print(line.rstrip())