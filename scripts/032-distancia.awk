BEGIN {FS="\t"; OFS="\t"; OFMT="%.3f"}
(NR==FNR) {gsub(/- /,"",$1); mapa[$2]=$1}
(NR!=FNR && NF==3) {distancia=$3 * 1.0 / length($1); locais[FILENAME][$1][$2]=distancia; if(FILENAME ~ /N0/) print $1,distancia,"N0",$2}
END {
	for(i = 4; 0 < i; i--) {
		for(nome in locais["090-N"i]) {
			for(m in locais["090-N"i][nome]) {
				n = m;

				for(j = i - 1; 0 <= j; j--) {
					n = mapa[n];
					
					if(nome in locais["090-N"j] && n in locais["090-N"j][nome])
						locais["090-N"i][nome][m] *= locais["090-N"j][nome][n];
				}

				print nome,locais["090-N"i][nome][m],"N"i,m;
			}
		}
	}
}
