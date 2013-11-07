#!/bin/sh

HELP()
{
	echo "CI_Make - automatizacia
	-h	vypise napovedu
	-t	subor sablony
	-n	meno, ktore sa nahradzuje
	-f	vysledny subor
	-g	po vytvoreni, sa otvori v Geany
	-c	vytvori controller z default sablony a automaticky ulozi
	-m	vytvori model z default sablony a automaticky ulozi"
}

geany=off
instant_controller=off
instant_model=off

while getopts  :t:n:f:c:m:gh param
do
  case $param in
	t) template="$OPTARG";;
	n) name="$OPTARG";;
	f) file="$OPTARG";;
	h) HELP; exit 0;;
	c) instant_controller=on; name="$OPTARG";;
	m) instant_model=on; name="$OPTARG";;
	g) geany=on;;
	\?) echo "Nespravny argument." 1>&2; exit 1;;
	:)  echo "Chyba argument" 1>&2; exit 1;;
  esac
done

# defaultne hodnoty
default_controller="c_default"
default_model="m_default"

# instant controller
if [ $instant_controller = on ];then
	
	male_pismena=`echo $name | tr '[A-Z]' '[a-z]'`
	
	if [ ! -f "controllers/$male_pismena.php" ];then
		cat "$default_controller" | sed "s/NAME/${name}/g" > "controllers/${male_pismena}.php"
		file="controllers/${male_pismena}.php"
	else
		echo "Subor existuje"
		echo "controllers/$male_pismena.php"
		exit 1
	fi
fi

# instant model
if [ $instant_model = on ];then
	
	male_pismena=`echo $name | tr '[A-Z]' '[a-z]'`
	
	if [ ! -f "controllers/$male_pismena.php" ];then
		cat "$default_model" | sed "s/NAME/${name}/g" > "models/${male_pismena}.php"
		file="models/${male_pismena}.php"
	else
		echo "Subor existuje"
		echo "models/$male_pismena.php"
		exit 1
	fi
fi

# klasicke 
if [ $instant_controller = off ] && [ $instant_model = off ];then
	if [ ! -f "$file" ];then
		cat "$template" | sed "s/NAME/${name}/g" > "$file"
	else
		echo "Subor existuje:"
		echo "$file"
		exit 1
	fi
fi


if [ $geany = on ];then
	geany "$file"
fi
