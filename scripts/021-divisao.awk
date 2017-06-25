BEGIN {FS="\t"; OFS="\t"}
(NR==FNR) {print "- "$0}
(NR==FNR && $0 !~ /^-/) {mapa[$2]}
(NR!=FNR && $1 in mapa) {print $1,$2}
