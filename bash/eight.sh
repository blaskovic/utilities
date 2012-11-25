#!/bin/bash

#
# Freakin IZP proj3 2012 solution
# Author: Branislav Blaskovic
#         branislav@blaskovic.sk
#
# patient.. patient.. bash is not as fast as C :)
#

#
# Function to get indexed char
# (row, column, tolower)
#
function index()
{
    test x$3 = "xtrue" && low=1 || low=0
    echo -n $chars | awk -v offset=$columns -v row=$1 -v column=$2 -v low=$low '{tmp=$((offset * (row - 1)) + column); if(low) print tolower(tmp); else print tmp;}'
}

#
# Function to print matrix
# ()
#
function print_matrix()
{
    echo "$rows $columns"
    for r in `seq 1 $rows`
    do
        for c in `seq 1 $columns`
        do
            echo -n `index $r $c`" "
        done
        echo
    done
}

#
# Print solution
# ()
#
function print_solution()
{
    for char in `echo $chars`
    do
        a=`echo $char | grep [a-z]`
        echo -n $a
    done
    echo
}

#
# Function to mark word by his indexes
# (indexes)
#
function mark_word()
{

    for index in `echo $1`
    do
        chars=`echo $chars | awk -v ind=$index '{$(ind)=toupper($(ind)); print $0}'`
    done
    export chars
}

#
# Validate borders
# (row, column)
#
function validate_borders()
{
    test $1 -le 0 && echo 1 && return
    test $2 -le 0 && echo 2 && return
    test $1 -gt $rows && echo 3 && return
    test $2 -gt $columns && echo 4 && return

    echo 0
}

#
# Function to find word in matrix
# (word)
#
function find_word()
{
    word=$1
    len=$((${#word} - $(echo $word | sed "s/ch/ch\n/g" | grep -c "ch") - 1))

    for r in `seq 1 $rows`
    do
        for c in `seq 1 $columns`
        do
            # Count word length and count 'ch' once

            # Right
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=$r
                newC=`expr $c + $i`
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"

            # Left
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=$r
                newC=`expr $c - $i`
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"

            # Up
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=`expr $r - $i`
                newC=$c
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"

            # Down
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=`expr $r + $i`
                newC=$c
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"

            # Right Up
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=`expr $r + $i`
                newC=`expr $c + $i`
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"

            # Right Down
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=`expr $r - $i`
                newC=`expr $c + $i`
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"

            # Left Up
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=`expr $r + $i`
                newC=`expr $c - $i`
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"

            # Left Down
            load="";indexes=""
            for i in `seq 0 $len`
            do
                newR=`expr $r - $i`
                newC=`expr $c - $i`
                [ `validate_borders $newR $newC` -ne 0 ] && break
                load="$load"`index $newR $newC true`
                indexes="$indexes $((($columns * ($newR - 1)) + $newC))"
            done
            test x"$load" = x"$word" && mark_word "$indexes"
        done
    done
}

test $# -lt 2 && echo "Bad params..." && exit 1

#
# Load file
#
i=0
chars=""
rows=0
columns=0
for a in `cat $2`
do
    # Numbers
    if [ $i -eq 0 ]; then rows=$a
    elif [ $i -eq 1 ]; then columns=$a

    # Chars
    else
        chars="$chars $a"
    fi

    let i++ 
done

# print_matrix
# print_solution
# find_word


if [ $# -eq 2 ]
then
    find_word "${1:9}"
    print_matrix
fi


if [ $# -eq 3 ]
then
    for word in `cat $3`
    do
        echo "Searching for '$word' ..." >&2
        find_word "$word"
    done
    print_solution
fi
