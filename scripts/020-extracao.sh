#!/bin/sh
cd ../

# Usuarios
7z x -o/run/shm fontes/stackoverflow.com-Users.7z
grep '\sLocation="[^"]*\w\{2,\}' /run/shm/Users.xml | sed -r 's/.*\s((Id|Location)="[^"]*").*\s((Id|Location)="[^"]*").*/Site="SO";\1;\3/' > /run/shm/010-so-users

sed -r 's/.*"\s\},\s"/site:"GH";/; s/"\s:\s"?/:"/g; s/"?,\s"((id|location):")/";\1/; s/"?\s*}\s*$/";/' fontes/github-users.json > /run/shm/020-gh-users
