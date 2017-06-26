#!/bin/sh
cd ../dados/

echo 'INSERT INTO locais (id,nome,lat,lng) VALUES' > locais.sql
cat R? | grep -o '\S\+\s*$' | sort -u | awk -v aa='"' 'BEGIN{FS="\t"; OFS=","} (NR==FNR){mapa[$1]} (NR!=FNR && $1 in mapa){print "("$1,aa $2 aa,$5,$6"),"}' - gazetteer >> locais.sql


echo 'INSERT INTO usuarios (id,site,versao,local,algoritmo,local_id) VALUES' > usuarios.sql
awk 'BEGIN{FS="\t"; OFS="\t"} {print $1,FILENAME,$NF}' R? | sort > /run/shm/070-mapa
awk 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR){mapa[$1]=$0} (NR!=FNR && $4 in mapa){print $1,$2,$3,mapa[$4]}' /run/shm/070-mapa localizacao > /run/shm/071-mapa
awk -v aa='"' 'BEGIN{FS="\t"; OFS=","} (NR==FNR){mapa[$1,$2,$3]=aa $5 aa","$6} (NR!=FNR){m=mapa[$1,$2,$3]; print "("$1,aa $2 aa,$3,aa $4 aa,(m ? m : "NULL,NULL")"),"}' /run/shm/071-mapa usuarios >> usuarios.sql
