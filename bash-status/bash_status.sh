#!/bin/bash

#
# Branislav Blaskovic
#
test ! -f `dirname $0`/brano_curses.sh && $(echo "Missing gile brano_curses.sh"; exit 1)
. `dirname $0`/brano_curses.sh

IFS=$'\n'
VPS_IP="31.31.72.75"
VPS_USER="blaskovic"
IRC_LOG_DIR="/home/branislav/Documents/irclogs/IRCnet-#fitgame.log"
IRC_REMOTE_FILE="/home/brano/Documents/irclogs/IRCnet-#fitgame.log"

tmp_df=$(mktemp)
tmp_uptime=$(mktemp)
tmp_cal=$(mktemp)
tmp_irclog=$(mktemp)


update_vps_data()
{
	while :
	do
		ssh $VPS_USER@$VPS_IP uptime > $tmp_uptime
		ssh $VPS_USER@$VPS_IP df -h > $tmp_df
		sleep 300
	done
}

update_irc_log()
{
	while :
	do
		scp -P 60000 brano@192.168.2.105:$IRC_REMOTE_FILE $tmp_irclog  2>&1 >aa
		sleep 60
	done
}

update_cal()
{
	while :
	do
		gcalcli agenda > $tmp_cal
		sleep 300
	done
}

cleanup()
{
	echo
	echo "Cleaning.. exiting.."
	rm -f $tmp_df
	rm -f $tmp_uptime
	rm -f $tmp_irclog
	rm -rf $BUFFER
	kill $pid_update_vps
	kill $pid_update_cal
	kill $pid_update_irc
	exit 0
}

main()
{
	clear
	# My PC
	window "Calendar" "blue"
	cat $tmp_cal

	window "Highlights" "blue"
	cat $tmp_irclog | grep -iv "brano>\|brano|pi>" | grep -i brano | tail

	# VPS
	window "VPS df -h" "blue"
	cat $tmp_df

	window "VPS uptime" "blue"
	cat $tmp_uptime
}

trap cleanup SIGINT SIGTERM

update_vps_data &
pid_update_vps=$!

update_cal &
pid_update_cal=$!

update_irc_log &
pid_update_irc=$!

time=1
while :
do
	refresh
	sleep $time
done

