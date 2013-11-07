<?php

function najdi_novu_url( $pole )
{
	foreach( $pole as $hodnota )
	{
		# zhoda
		if( strpos( $hodnota, "Location" ) === 0 ) {
			return trim( str_replace("Location:", "", $hodnota ));
		}
	}
	
	# nenasla sa url
	return FALSE;
}

# vstupne parametre
$vstup_url = @$_SERVER['argv'][1];
if( strlen( $vstup_url ) < 1 ) {
	# nezadane vstupne parametre
	echo "Musite zadat url ako argument\n";
	exit();
}

# prvotna adresa
$url = trim($vstup_url);

$presmerovanie = TRUE;
define('DEBUG', FALSE);

while( $presmerovanie )
{
	# ziskam hlavicky
	$hlavicka = get_headers($url);
	
	if( DEBUG ) print_r($hlavicka);
	
	# ak je presmerovanie
	if( strpos( $hlavicka[0], '301 Moved' ) ) {
		
		# ziskame novu url z Location:
		$url = najdi_novu_url( $hlavicka );
		
		# ak sa URL nenasla
		if( $url == FALSE ) {
			echo "Nastalo presmerovanie, ale ziadna URL sa nenasla..";
			exit();
		}
		
	} else {
		
		# inak mame koncovu URL (popripade 404, 500, atd, mozme vypisat)
		# vypadneme z cyklu
		$presmerovanie = FALSE;
		
	}
}

echo "Koncova url je: \n";
echo $url;
echo "\n";

?>
