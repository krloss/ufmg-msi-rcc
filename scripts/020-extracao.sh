#!/bin/sh
cd ../

# Usuarios
7z x -o/run/shm fontes/stackoverflow.com-Users.7z
grep '\sLocation="[^"]*\w\{2,\}' /run/shm/Users.xml | sed -r 's/.*\s((Id|Location)="[^"]*").*\s((Id|Location)="[^"]*").*/Site="SO";\1;\3/' > /run/shm/010-so-users
