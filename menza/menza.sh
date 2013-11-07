#!/bin/bash

declare -A MENZY=([10]="Purkynova" [20]="Kolejni" [18]="Mozzarella" [5]="Pivovar")

if [ $# -eq 0 ] ; then

    echo "Podporujem menzy:"
    for id in "${!MENZY[@]}"
    do
       echo "`basename $0` ${MENZY["$id"]}"
    done

    exit 0

fi

test $# -ne 1 && echo "Dostal som $# argumenty a to je vela" && exit 1

# Exist?
chid=x
for id in "${!MENZY[@]}"
do
    if [ ${MENZY["$id"]} = "$1" ]; then
        chid=$id
        break
    fi
done

test $chid = "x" && echo "Menza nenajdena. Spusti program bez argumentov pre zoznam." && exit 1

curl -s "http://www.kam.vutbr.cz/?p=menu&provoz=$chid" | grep '<tr id="r' | sed -E 's/.+?onClick="slo\([0-9]+\)">(.*?)<!--.*?slcen1">([0-9]+).*/\1 \2 kc/'
