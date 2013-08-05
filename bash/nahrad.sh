#!/bin/sh

#
# Branislav Blaskovic
# za skody sposobene scriptom nerucim
#

# Nahlad pre uzivatela
grep --colour=auto --color=always -nrHIF "$1" * | nl

# vytvorime si pomocne subory
temp1=`mktemp`
temp2=`mktemp`

# ulozime vystup do pomocneho subora a ocislujeme riadky
grep --colour=auto -nrHIF "$1" * | cat -n - | sed 's/	/:/' | sed 's/     //' > "$temp1"

# Overime, ci sme vobec nieco nasli
if [ `cat "$temp1" | wc -l` -eq 0 ];then
	echo "\"$1\" sa nenaslo."
	# Upratujeme po sebe
	rm -f "$temp1" 2> /dev/null
	rm -f "$temp2" 2> /dev/null
	exit 0
fi

# Spytame sa, ktore riadky chcem zamenit
# vstup je v tvare "cislo" popripade "cislo-vyskytNaRiadku" a oddelene medzerami
echo "Ktore riadky nahradit so slovom \"$2?\""
read riadky

# ak chcem vsetky riadky
if [ "$riadky" = "0" ];then
	pocetRiadkov=`cat "$temp1" | wc -l`
	riadky=`seq 1 $pocetRiadkov`
fi

# Prejdeme zvolene riadky
for i in $riadky
do

	# zistime, ci bol zadany presny vyskyt, ak nie, tak pouzivam "g" ako global
	vyskyt=`echo "$i" | awk -F- '{ print $2; }'`
	if [ "$vyskyt" != "" ];then
		kolkaty="$vyskyt"
		i=`echo "$i" | awk -F- '{ print $1; }'`
	else
		kolkaty="g"
	fi
	
	# ziskame cislo riadka
	riadok=`cat "$temp1" | grep "^$i:"`
	# ziskame nazov subora
	subor=`echo "$riadok" | awk -F: '{ print $2; }'`
	cisloRiadka=`echo "$riadok" | awk -F: '{ print $3; }'`	
	# nahradime do tempu a naspat do subora
	sed "${cisloRiadka}s/${1}/${2}/${kolkaty}" "$subor" > "$temp2"
	mv "$temp2" "$subor"
	chmod 644 $subor
	
done

# Upratujeme po sebe
rm -f "$temp1" 2> /dev/null
rm -f "$temp2" 2> /dev/null
