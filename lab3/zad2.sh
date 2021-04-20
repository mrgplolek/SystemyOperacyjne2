#!/bin/bash -eu

#Zadanie 2
# 1)
# Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą. 
# Wyniki zapisz na standardowe wyjście błędów.
# 2)
# Z pliku yolo.csv wypisz każdego, kto jest wart dokładnie $2.99 lub $5.99 lub $9.99.
# Nie wazne czy milionów, czy miliardów (tylko nazwisko i wartość). Wyniki zapisz na standardowe wyjście błędów
# 3)
# Z pliku yolo.csv wypisz każdy numer IP, który w pierwszym i drugim oktecie ma po jednej cyfrze. 
# Wyniki zapisz na standardowe wyjście błędów"

# Podpunkt 1
cat ./pliczki/yolo.csv | sed 1d | cut -d',' -f1,2,3 | grep -E "^[0-9]{0,}[13579]," 1>&2
echo -e "\nWcisnij ENTER aby przejsc do kolejnego podpunktu"
read stop

# Podpunkt 2
cat ./pliczki/yolo.csv | sed 1d | cut -d',' -f3,7 | grep -E '\$[259]\.[9]{2}[BM]' 1>&2
echo -e "\nWcisnij ENTER aby przejsc do kolejnego podpunktu"
read stop

# Podpunkt 3
cat ./pliczki/yolo.csv | sed 1d | cut -d',' -f6 | grep -E "^[0-9]\.[0-9]\.[0-9]{1,3}\.[0-9]{1,3}" 1>&2
echo -e "\nWcisnij ENTER aby zakonczyc"
read stop