#!/bin/bash

#
# Branislav Blaskovic
# IRSSI notificator
# start like this:
# nohup notificator.sh &
#

echo "Starting IRSSI notificator"

LOG="/home/branislav/irclogs/"
TMP=`mktemp -d`
GREP="brano"

# Clean temporary files
clean_up()
{
	echo "Cleaning shits.."
	rm -rf "$TMP"
	exit 0
}

trap clean_up SIGINT SIGTERM

# Loop it!
while true
do
	for log in `find $LOG -type f`
	do
		base=`basename $log`

		# Diffing
		diff "$log" "$TMP/$base" 2>/dev/null | grep "^<" | sed 's/<//' > "$TMP/$base.diff"

		grep -i "$GREP" "$TMP/$base.diff" | grep -iv "<.$GREP>" | head -n1 > "$TMP/$base.grep"

		# Have something to notify
		if [ `cat "$TMP/$base.grep" | wc -l` -gt 0 ];then
			notify-send -i "/home/branislav/Documents/bin/irssi.png" -t 3000 "IRSSI: $base" "`cat \"$TMP/$base.grep\"`"
		fi

		cp "$log" "$TMP/$base"
		sleep 2
	done
done

