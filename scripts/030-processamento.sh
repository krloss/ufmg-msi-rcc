#!/bin/sh
cd ../dados/
ln -rs ../ /run/shm/origem
awk 'BEGIN{FS="\t"; OFS="\t"} {gsub(/\W|_/,"",$3); if(length($3) > 1) print toupper($0)}' usuarios > /run/shm/030-users-location
cut -f 3 /run/shm/030-users-location | grep '[A-Z]' | sort -u > /run/shm/040-locations

# Algoritmo R0: Encontra localização por sigla do país(casamento exato)
awk 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR){m3[$2]=$6; m2[2 == length($3) ? $3 : $1]=$6} (NR!=FNR && $0 in m3){print $0,m3[$0]} (NR!=FNR && $0 in m2){print $0,m2[$0]}' paises /run/shm/040-locations > R0
awk -F '\t' '(NR==FNR){mapa[$1]} (NR!=FNR && !($1 in mapa)){print $0}' R0 /run/shm/040-locations > /run/shm/041-locations


awk 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR){mapa[$2]} (NR!=FNR && $1 in mapa){print $0}' divisoes gazetteer > /run/shm/050-mini-gazetteer
awk -v adm='^(- ){4}[^-]' 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR && $0 ~ adm){mapa[$2]} (NR!=FNR && $1 in mapa){print $0}' divisoes /run/shm/050-mini-gazetteer | sort -u > /run/shm/060-divisao
awk -v adm='^(- ){3}[^-]' 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR && $0 ~ adm){mapa[$2]} (NR!=FNR && $1 in mapa){print $0}' divisoes /run/shm/050-mini-gazetteer | sort -u > /run/shm/061-divisao
awk -v adm='^(- ){2}[^-]' 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR && $0 ~ adm){mapa[$2]} (NR!=FNR && $1 in mapa){print $0}' divisoes /run/shm/050-mini-gazetteer | sort -u > /run/shm/062-divisao
awk -v adm='^(- ){1}[^-]' 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR && $0 ~ adm){mapa[$2]} (NR!=FNR && $1 in mapa){print $0}' divisoes /run/shm/050-mini-gazetteer | sort -u > /run/shm/063-divisao
awk -v adm='^(- ){0}[^-]' 'BEGIN{FS="\t"; OFS="\t"} (NR==FNR && $0 ~ adm){mapa[$2]} (NR!=FNR && $1 in mapa){print $0}' divisoes /run/shm/050-mini-gazetteer | sort -u > /run/shm/064-divisao

# Algoritmo R1: Encontra localização por regex em nomes(correspondência completa)
awk -v nome=4 -v id=6 'BEGIN{FS="\t"; OFS="\t"} {gsub(/\W/,"",$nome); local=toupper($nome); system("grep \""local"\" /run/shm/041-locations | sed \"s/$/\t"$id"\t"length(local)"/\"")}' paises > /run/shm/070-N0
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS="\t"} {gsub(/\W/,"",$nome); local=toupper($nome); system("grep \""local"\" /run/shm/041-locations | sed \"s/$/\t"$id"\t"length(local)"/\"")}' /run/shm/061-divisao > /run/shm/070-N1
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS="\t"} {gsub(/\W/,"",$nome); local=toupper($nome); system("grep \""local"\" /run/shm/041-locations | sed \"s/$/\t"$id"\t"length(local)"/\"")}' /run/shm/062-divisao > /run/shm/070-N2
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS="\t"} {gsub(/\W/,"",$nome); local=toupper($nome); system("grep \""local"\" /run/shm/041-locations | sed \"s/$/\t"$id"\t"length(local)"/\"")}' /run/shm/063-divisao > /run/shm/070-N3
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS="\t"} {gsub(/\W/,"",$nome); local=toupper($nome); system("grep \""local"\" /run/shm/041-locations | sed \"s/$/\t"$id"\t"length(local)"/\"")}' /run/shm/064-divisao > /run/shm/070-N4

cd /run/shm/
awk -f origem/scripts/031-criterio.awk origem/dados/divisoes 070-N* > 080-criterios
cd origem/dados/
grep -vP '\t0\.([01]|2[0-4])[0-9]*\t' /run/shm/080-criterios | sort -k1,1 -k2r,2 -k3,3 -k4r | sort -uk 1,1 > R1
awk -F '\t' '(NR==FNR){mapa[$1]} (NR!=FNR && !($1 in mapa)){print $0}' R1 /run/shm/041-locations > /run/shm/042-locations


# Algoritmo R2: Encontra localização por regex dos topônimos
awk 'BEGIN{FS="\t"; OFS="\t"} ($4 ~ /\S{2,}/){gsub(/,/,"_",$4); gsub(/\W/,"",$4); print $1,toupper($4)}' gazetteer | sort -k1nr,1 -k2 -u > /run/shm/051-mini-gazetteer
awk '{n=$0; grep="grep -m 1 \"[\t_]"n"[_$]\" gazetteer"; grep | getline; close(grep); if(n != $0) print n"\t"$1}' /run/shm/051-mini-gazetteer > R2
awk -F '\t' '(NR==FNR){mapa[$1]} (NR!=FNR && !($1 in mapa)){print $0}' R2 /run/shm/042-locations > /run/shm/043-locations


awk -v nome=4 -v id=6 'BEGIN{FS="\t"; OFS=";"} {gsub(/\W/,"",$nome); print $id,toupper($nome)}' paises > /run/shm/065-D0
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS=";"} {gsub(/\W/,"",$nome); print $id,toupper($nome)}' /run/shm/061-divisao > /run/shm/065-D1
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS=";"} {gsub(/\W/,"",$nome); print $id,toupper($nome)}' /run/shm/062-divisao > /run/shm/065-D2
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS=";"} {gsub(/\W/,"",$nome); print $id,toupper($nome)}' /run/shm/063-divisao > /run/shm/065-D3
awk -v nome=2 -v id=1 'BEGIN{FS="\t"; OFS=";"} {gsub(/\W/,"",$nome); print $id,toupper($nome)}' /run/shm/064-divisao > /run/shm/065-D4

# Algoritmo R3: Encontra localização através da distância editável
cd ../scripts/
pip install -t distEditavel/ nltk
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/065-D0 > /run/shm/090-N0
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/065-D1 > /run/shm/090-N1
split /run/shm/065-D2 -l 21278 /run/shm/066-D2
split /run/shm/065-D3 -l 40000 /run/shm/066-D3
split /run/shm/065-D4 -l 30428 /run/shm/066-D4
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/066-D2aa > /run/shm/091-N2a
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/066-D2ab > /run/shm/091-N2b
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/066-D3aa > /run/shm/091-N3a
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/066-D3ab > /run/shm/091-N3b
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/066-D4aa > /run/shm/091-N4a
distEditavel/ned.py ';' /run/shm/043-locations /run/shm/066-D4ab > /run/shm/091-N4b
cat /run/shm/091-N2* | sort -k1,1 -k3n,3 -k2nr,2 | sort -uk1,1 > /run/shm/090-N2
cat /run/shm/091-N3* | sort -k1,1 -k3n,3 -k2nr,2 | sort -uk1,1 > /run/shm/090-N3
cat /run/shm/091-N4* | sort -k1,1 -k3n,3 -k2nr,2 | sort -uk1,1 > /run/shm/090-N4
cd /run/shm/
awk -f origem/scripts/032-distancia.awk origem/dados/divisoes 090-N* > 081-distancias
cd origem/dados/
grep -P '\t0\.([0-5]|6[0-4])[0-9]*\t' /run/shm/081-distancias | sort -k1,3 -k4r | sort -uk1,1 > R3
awk -F '\t' '(NR==FNR){mapa[$1]} (NR!=FNR && !($1 in mapa)){print $0}' R3 /run/shm/043-locations > _R
