#!/bin/sh
cd ../dados/
ln -rs ../ /run/shm/origem
awk 'BEGIN{FS="\t"; OFS="\t"} {gsub(/\W|_/,"",$3); if(length($3) > 1) print toupper($0)}' usuarios > /run/shm/030-users-location
cut -f 3 /run/shm/030-users-location | grep '[A-Z]' | sort -u > /run/shm/040-locations

# Algoritmo R0: Encontra localização por sigla do país(casamento exato)
awk 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR){m3[$2]=$6; m2[2 == length($3) ? $3 : $1]=$6} (NR!=FNR && $0 in m3){print $0,m3[$0]} (NR!=FNR && $0 in m2){print $0,m2[$0]}' paises /run/shm/040-locations > R0
awk -F '\t' '(NR==FNR){mapa[$1]} (NR!=FNR && !($1 in mapa)){print $0}' R0 /run/shm/040-locations > /run/shm/041-locations
