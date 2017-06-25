#!/bin/sh
cd ../fontes/

wget -b https://archive.org/download/stackexchange/stackoverflow.com-Users.7z

ssh-keygen -t rsa -b 2048 -C "carloss@ufmg.br" # ./id_rsa
# GitHub fork project https://github.com/ghtorrent/ghtorrent.org.git
git clone https://github.com/krloss/ghtorrent.org.git; cd ghtorrent.org/
cat ../id_rsa.pub >> keys.txt; git commit -am 'Add key'; git push
# Create pull request
cd ../
ssh -i ssh_rsa_key -NfL *:8017:dutihr.st.ewi.tudelft.nl:27017 ghtorrent@dutihr.st.ewi.tudelft.nl
mongoexport -u ghtorrentro -p ghtorrentro -d github -c users -q '{location:/\\S{2,}/}' -f id,location -o github-users.json

wget -b http://download.geonames.org/export/dump/allCountries.zip
wget -b http://download.geonames.org/export/dump/countryInfo.txt
wget -b http://download.geonames.org/export/dump/hierarchy.zip
