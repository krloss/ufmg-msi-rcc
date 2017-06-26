#!/bin/sh
cd ../

# Usuarios
7z x -o/run/shm fontes/stackoverflow.com-Users.7z
grep '\sLocation="[^"]*\w\{2,\}' /run/shm/Users.xml | sed -r 's/.*\s((Id|Location)="[^"]*").*\s((Id|Location)="[^"]*").*/Site="SO";\1;\3/' > /run/shm/010-so-users
rm /run/shm/Users.xml

sed -r 's/.*"\s\},\s"/site:"GH";/; s/"\s:\s"?/:"/g; s/"?,\s"((id|location):")/";\1/; s/"?\s*}\s*$/";/' fontes/github-users.json > /run/shm/011-gh-users

cat /run/shm/*-users | sed -r 's/.*([Ii]d[:=]"[^"]*").*/\1;&/; s/;([Ii]d[:=]"[^"]*")//; s/([Ii]d|[Ss]ite|[Ll]ocation)[:=]"/"/g' | sed -r 's/\s+/ /g; s/";"/\t/g; s/^"|";*$//g' | sort -u > /run/shm/012-users
awk 'BEGIN{FS="\t"; OFS="\t"} {print $1,$2,versao[$1,$2]++,$3}' /run/shm/012-users > dados/usuarios

# Enderecos
unzip fontes/allCountries.zip -d /run/shm/
awk -F '\t' '($7 ~ /A|P/){print $0}' /run/shm/allCountries.txt | sort -u >  dados/gazetteer

grep '^\w' fontes/geonames_countryInfo.txt | cut -f -2,4,5,9,17 | sort -u > dados/paises

unzip fontes/hierarchy.zip -d /run/shm/
cd scripts/
cut -f 4,6 ../dados/paises | awk -f 021-divisao.awk - /run/shm/hierarchy.txt | awk -f 021-divisao.awk - /run/shm/hierarchy.txt | awk -f 021-divisao.awk - /run/shm/hierarchy.txt | awk -f 021-divisao.awk - /run/shm/hierarchy.txt | sort -u > ../dados/divisoes
