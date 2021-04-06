#!/bin/bash -eu


JEDYNECZKA=${1}
DWOJECZKA=${2}

echo -e "Wpisales ${JEDYNECZKA} oraz ${DWOJECZKA} \n" #gdy, któraś ze ścieżek wyrzuci błąd to tutaj się on pojawi


PLIKI_W_JEDYNECZCE=$(ls ${JEDYNECZKA})
for PLIK in $PLIKI_W_JEDYNECZCE
do
    if [[ -d "${JEDYNECZKA}/${PLIK}" ]]; then #flaga -d czyli plik istnieje i jest to folder
        if [[ -L "${JEDYNECZKA}/${PLIK}" ]]; then #tu jest sprawdzane czy to katalog czy dowiazanie
            echo "${PLIK} to dowiazanie symboliczne (tzw. link)"
        else
            echo "${PLIK} to katalog"
			P=${PLIK}
			TEMP_NAME="${P%.*}_ln.${P##*.}"
			ln -s "../${JEDYNECZKA}/${PLIK}" "${DWOJECZKA}/${TEMP_NAME}" #komenda ln tworzy dowiazanie o zadanej nazwie w odpowiednim miejscu
        fi
    else
        if [[ -L "${JEDYNECZKA}/${PLIK}" ]]; then
            echo "${PLIK} to dowiazanie symboliczne (tzw. link)"
        else
            echo "${PLIK} to plik regularny"
			P=${PLIK}
			TEMP_NAME="${P%.*}_ln.${P##*.}"
			ln -s "../${JEDYNECZKA}/${PLIK}" "${DWOJECZKA}/${TEMP_NAME}"
        fi
	fi


done
