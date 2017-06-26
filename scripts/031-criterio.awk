BEGIN {FS="\t"; OFS="\t"; OFMT="%.3f"}
(NR==FNR) {gsub(/- /,"",$1); mapa[$2]=$1}
(NR!=FNR) {criterio=$3 * 1.0 / length($1); locais[FILENAME][$1][$2]=criterio; if(FILENAME ~ /N0/) print $1,criterio,"N0",$2}
END {
	for(i = 4; 0 < i; i--) {
		for(nome in locais["050-N"i]) {
			for(m in locais["050-N"i][nome]) {
				n = m;

				for(j = i - 1; 0 <= j; j--) {
					n = mapa[n];
					
					if(nome in locais["050-N"j] && n in locais["050-N"j][nome])
						locais["050-N"i][nome][m] += locais["050-N"j][nome][n];
				}

				print nome,locais["050-N"i][nome][m],"N"i,m;
			}
		}
	}
}
