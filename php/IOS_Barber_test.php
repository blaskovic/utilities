<?php 
error_reporting(E_ALL & ~E_NOTICE);
if( $_POST ) {
	
	if( $_GET['wget'] == 1 ) $wget = true;
	
	$_POST['text']  = htmlspecialchars($_POST['text']);
	
	$t_ex = explode("\n", $_POST['text']);

	if( count( $t_ex ) < 2 ) {
		echo "<strong>Do okna VYSTUP musis zadat tvoj vystup z tvojho programu barber</strong>";
	}
	
	$_POST['stolicky'] = abs($_POST['stolicky']);
	$_POST['zakaznici'] = abs($_POST['zakaznici']);
	
	if( !is_numeric( $_POST['stolicky'] ) || !is_numeric( $_POST['zakaznici'] ) ) {
		echo 'zadavaj ciselne hodnoty stoliciek aj zakaznikov';
		exit();
	}
	
	$stolicky = $_POST['stolicky'];	
	
	$pocet_v_cakarni = 0;
	
	if( is_array( $t_ex ) && count( $t_ex ) > 1 ) {
		
		foreach( $t_ex as $r ) {
			
			if( !empty($r) ) {
				
				$chyby = array();
				
				if( !$wget ) {
					echo $r.'<br>';
				}
				$h = explode(' ', $r);
				
				if( isset( $cislo_akcie ) ) {
					if( $cislo_akcie+1 != substr($h[0], 0, -1) ) {
						$chyby[] = 'cislo riadka nenadvazuje';
					}
					$cislo_akcie = substr($h[0], 0, -1);
				} else {
					if( substr($h[0], 0, -1) != 1 ) {
						$chyby[] = 'cislo riadka by malo zacinat s 1';
					}
					$cislo_akcie = substr($h[0], 0, -1);
				}
				
				/*
				 * 0 = cislo
				 * 1 = osoba
				 * 2 = cislo zakaznika / akcia barbera
				 * 3 = akcia zakaznika
				 * */
				
				if( $h[1] == 'barber:' ) {
					
					if( strpos($h[2], 'checks') === 0 ) {
						if( $b['striha'] == 1 ) {
							$chyby[] = 'prave striha';
						}
					} elseif( strpos($h[2], 'ready') === 0 ) {
						if( $pocet_v_cakarni < 1 ) {
							$chyby[] = 'nema ludi v cakarni';
						}
						if( $b['striha'] == 1 ) {
							$chyby[] = 'prave striha';
						}
						$b['ready'] = 1;
						
					} elseif( strpos($h[2], 'finished') === 0 ) {
						if( $b['ready'] != 1 ) {
							$chyby[] = 'nebol ready';
						}
						if( $z_bol_ready != 1 ) {
							$chyby[] = 'ziadny zakaznik nebol ready';
						}
						$b['ready'] = 0;
						$b['finished'] = 1;
						$b['striha'] = 0;
						
					} else {
						$chyby[] = 'nepoznam akciu: '.$h[2];
					}
				
				} elseif( $h[1] == 'customer' ) {
					
					$h[2] = substr($h[2], 0,-1);
					
					if( !is_numeric( $h[2] ) ) {
						$chyby[] = 'neplatne cislo zakaznika: '.$h[2];
					}
					
					if( strpos($h[3], 'created') === 0 ) {
						$z[$h[2]]['created'] = 1;
						
					} elseif( strpos($h[3], 'enters') === 0 ) {
						if( $z[$h[2]]['created'] != 1 ) {
							$chyby[] = 'zakaznik nebol vytvoreny';
						}
						$z[$h[2]]['enters'] = 1;
						$pocet_v_cakarni++;
						$stolicky--;
						
					} elseif( strpos($h[3], 'ready') === 0 ) {
						if( $z[$h[2]]['enters'] != 1 ) {
							$chyby[] = 'zakaznik nevstupil';
						}
						if( $z[$h[2]]['refused'] == 1 ) {
							$chyby[] = 'zakaznik uz bol odmienuty';
						}
						if( $b['ready'] != 1 ) {
							$chyby[] = 'holic nebol ready';
						}
						
						$z[$h[2]]['ready'] = 1;
						$b['striha'] = 1;
						$stolicky++;
						$z_bol_ready = 1;
						if( $stolicky < 0 ) {
							$chyby[] = 'zakaznik mal byt odmienuty, lebo nemal miesto na sedenie';
						}
					
					} elseif( strpos($h[3], 'served') === 0 ) {
						if( $z[$h[2]]['ready'] != 1 ) {
							$chyby[] = 'zakaznik nebol ready';
						}
						if( $b['finished'] != 1 ) {
							$chyby[] = 'holic nebol finished';
						}
						$z[$h[2]]['served'] = 1;
						$z[$h[2]]['ukonceny'] = 1;
						$b['finished'] = 0;
						$pocet_v_cakarni--;
						$z_bol_ready = 0;
					
					} elseif( strpos($h[3], 'refused') === 0 ) {
						if( $z[$h[2]]['enters'] != 1 ) {
							$chyby[] = 'zakaznik nevstupil';
						}
						
						$z[$h[2]]['refused'] = 1;
						$z[$h[2]]['ukonceny'] = 1;
						$pocet_v_cakarni--;
						$stolicky++;
						$z[$h[2]]['problem_miesto'] = 0;
						
					} else {
						$chyby[] = 'nepoznam akciu: '.$h[3];
					}
					//echo $stolicky.'<br>';
				}
				
				if( count($chyby) > 0 ) {
					if( !$wget ) {
						echo '<font color="red" style="font-size:10px;">';
					}
					for($i = 0; $i < count($chyby); $i++ ) {
						if( !$wget ) echo $chyby[$i].'<br>';
								else echo 'r:'.$h[0].' '.$chyby[$i]."\n";
					}
					if( !$wget ) echo '</font>';
				}

			}

		}
		
		// dodatocne chyby
		$chyby = array();
		if( $pocet_v_cakarni != 0 ) {
			$chyby[] = 'v cakarni zostalo zakaznikov: '.$pocet_v_cakarni;
		}
		for( $i = 1; $i <= $_POST['zakaznici']; $i++ ) {
			if( $z[$i]['ukonceny'] != 1 ) {
				$chyby[] = 'zakaznik cislo '.$i.' nebol ani finished, ani refused';
			}
			if( !is_array( $z[$i] ) ) {
				$chyby[] = 'zakaznik cislo '.$i.' sa nevyskytol vo vypise';
			}
		}
		foreach( $z as $z1 => $z2 ) {
			if( $z1 < 1 || $z1 > $_POST['zakaznici'] ) {
				$chyby[] = 'zakaznik cislo '.$i.' by sa vobec nemal vyskytovat';
			}
		}
		
		if( count($chyby) > 0 ) {
			if( !$wget ) {
				echo '<font color="red" style="font-size:10px;">';
			}
			for($i = 0; $i < count($chyby); $i++ ) {
				echo $chyby[$i];
				if( $wget ) {
					echo "\n";
				} else {
					echo "<br>";
				}
			}
			if( !$wget ) echo '</font>';
		}
		
	}
	
}

if( !$wget ) {
echo '<hr>';
?>

<form method="post">
Pocet stoliciek: <input type="text" size="3" name="stolicky" value="<?php echo $_POST['stolicky']; ?>">
<br>
Pocet zakaznikov: <input type="text" size="3" name="zakaznici" value="<?php echo $_POST['zakaznici']; ?>">
<br>
Vystup:
<br>
<textarea name="text" rows="20" cols="30"><?php echo $_POST['text']; ?></textarea>
<br>
<input type="submit" value="makaj">

</form>

<?php 
}
?>
