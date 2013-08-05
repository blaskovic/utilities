#!/bin/bash

. simple_curses.sh

# Set non-blocking reading
if [ -t 0 ]
then
    stty -echo -icanon time 0 min 0
fi

declare -A MENU=([1]="select 1" [2]="select 2" [3]="select 3")

key=''
cursor=1
main()
{
    # Main menu
    window "Menu" "red" "33%"
        for id in "${!MENU[@]}"
        do
           sel="  "
           test $cursor -eq $id && sel="\*"
           append "$sel ${MENU["$id"]} $sel"
        done
    endwin

    # Start second col
    col_right 
    move_up

    # Main window
    window "Window" "red" "33%"
        append "Position $cursor"
    endwin
    
    read key

    # Handle keys
    test x"$key" = x"j" && let cursor++
    test x"$key" = x"k" && let cursor--
    
    # Exit
    test x"$key" = x"q" && break
}

# Start it!
main_loop 0.1

# Set everything back
if [ -t 0 ]
then
    stty sane
fi
