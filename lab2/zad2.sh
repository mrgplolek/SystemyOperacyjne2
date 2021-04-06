#!/bin/bash -eu

KATALOG=${1}
NAZWAPLIKU=${2}

DATA=$(date '+%Y-%m-%d') #zapis aktualnej daty w formacie ISO8601
USZKODZONE_LINKI=$(find ${KATALOG} -xtype l) #fukncja find -xtype przeprowadza "test" na linkach i sprawdza czy dzialają
for LINK in $USZKODZONE_LINKI 
do
   echo "${LINK} ${DATA}">>${NAZWAPLIKU} #Wpisanie uszkodzonego linku i daty do podanego pliku
   rm ${LINK} #usuniecie uszkodzonego linku
done