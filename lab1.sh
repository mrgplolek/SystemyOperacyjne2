#!/bin/bash

SOURCE_DIR=${1:-lab_uno}
RM_LIST=${2:-lab_uno/2remove}
TARGET_DIR=${3:-bakap}

if [[ ! -d ${TARGET_DIR} ]]; then
    mkdir ${TARGET_DIR}
    echo "Utworzono katalog ${TARGET_DIR}"
fi

# usuwanie plikow z RM_LIST
LISTA=$(cat ${RM_LIST})
for NAZWA_PLIKU in ${LISTA}
do
    if [[ -e ${SOURCE_DIR}/${NAZWA_PLIKU} ]]; then
        rm -r ${SOURCE_DIR}/${NAZWA_PLIKU}
        echo "Usunieto ${SOURCE_DIR}/${NAZWA_PLIKU}"
    fi
done

# przenoszenie plikow regularnych do TARGET_DIR
SRC_CONTENT=$(ls ${SOURCE_DIR})

for PLIK in ${SRC_CONTENT}; do
    if [[ -f ${SOURCE_DIR}/${PLIK} ]]; then
        mv ${SOURCE_DIR}/${PLIK} ${TARGET_DIR}
        echo "Przeniesiono plik regularny ${PLIK}"
    elif [[ -d ${SOURCE_DIR}/${PLIK} ]]; then
        cp -r ${SOURCE_DIR}/${PLIK} ${TARGET_DIR}
        echo "Skopiowano katalog ${PLIK}"
    fi
done


# liczenie pozostalych plikow
LICZBA_PLIKOW=$(ls ${SOURCE_DIR} | wc -w )
if [[ ${LICZBA_PLIKOW} -gt 0 ]]; then
    echo "Jeszcze cos zostalo"
    if [[ ${LICZBA_PLIKOW} -ge 2 ]]; then
        echo "Zostaly co najmniej dwa pliki"
        if [[ ${LICZBA_PLIKOW} -gt 4 ]]; then
            echo "Zostalo więcej niż 4 pliki"
        else
            echo "Cos napisane"
        fi
    fi
else
    echo "Tu byl Kononowicz"
fi

# odebranie praw do edycji z TARGET_DIR
TARGET_CONTENT=$(ls ${TARGET_DIR})
for PLIK in ${TARGET_CONTENT}; do
    chmod -w ${TARGET_DIR}/${PLIK}
    echo "Odebrano prawo do edycji pliku ${TARGET_DIR}/${PLIK}"
done

# pakowanie bakupu do .zip
DATE=$(date +%F)
tar -czf bakap_${DATE}.tar.gz $TARGET_DIR
echo "Spakowano bakup do bakap_${DATE}"
