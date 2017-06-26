#!/bin/sh
cd ../dados/

echo 'INSERT INTO ufmg_msi_rcc.locais (id,nome,lat,lng) VALUES' > locais.sql
cat R? | grep -o '\S\+\s*$' | sort -u | awk -v aa="'" 'BEGIN{FS="\t"; OFS=","} (NR==FNR){mapa[$1]} (NR!=FNR && $1 in mapa){print "("$1,aa $2 aa,$5,$6"),"}' - gazetteer >> locais.sql

#awk 'BEGIN{FS="\t"; OFS="\t"} {print $1,$NF,FILENAME}' R? | sort > /run/shm/100-mapa
#awk 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR){mapa[$1]=$2"\t"$5"\t"$6} (NR!=FNR){print $0,mapa[$2]}' gazetteer /run/shm/100-mapa > /run/shm/101-mapa
#awk 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR){mapa[$1]=$0} (NR!=FNR && $3 in mapa){print $1,$2,mapa[$3]}' /run/shm/101-mapa /run/shm/030-users-location > /run/shm/102-mapa
#awk 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR){mapa[$1,$2]=$4"\t"$5"\t"$6"\t"$7"\t"$8} (NR!=FNR){print $0,mapa[$1,$2]}' /run/shm/102-mapa usuarios > resultado
