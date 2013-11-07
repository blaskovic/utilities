#!/bin/bash

#
# Branislav Blaskovic
#

create_buffer()
{
	if [ -d "/dev/shm" ]; then
		BUFFER_DIR="/dev/shm"
	elif [ -z $TMPDIR ]; then
		BUFFER_DIR=$TMPDIR
	else
		BUFFER_DIR="/tmp"
	fi

	[[ "$1" != "" ]] &&  buffername=$1 || buffername="brano_curses"

	# Try to use mktemp before using the unsafe method
	if [ -x `which mktemp` ]; then
		mktemp --tmpdir=${BUFFER_DIR} ${buffername}.XXXXXXXXXX
	else
		echo "${BUFFER_DIR}/brano_curses."$RANDOM
	fi
}

BUFFER=`create_buffer`

change_color()
{
    case $1 in
        green)
            echo -n -e "\E[01;32m"
            ;;
        red)
            echo -n -e "\E[01;31m"
            ;;
        blue)
            echo -n -e "\E[01;34m"
            ;;
        grey|*)
            echo -n -e "\E[01;37m"
            ;;
    esac
}

clear_color()
{
    echo -n -e "\e[00m"
}

draw_line()
{
	num=`tput cols`
	echo -n "+"
	for i in `seq 3 $num`
	do
		echo -n "$1"
	done
	echo -n "+"
}

window()
{
	change_color $2
	draw_line "-"
	echo " $1"
	draw_line "-"
	clear_color
}

refresh()
{
	tput cup 0 0 >> $BUFFER
	tput il $(tput lines) >>$BUFFER
	main >> $BUFFER 
	tput cup $(tput lines) $(tput cols) >> $BUFFER 
	main > $BUFFER
	cat $BUFFER
	echo "" > $BUFFER
}
