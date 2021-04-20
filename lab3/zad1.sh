#!/bin/bash -eu
#Zadanie 1
#1) Znajdź w pliku access_log zapytania, które mają frazę ""denied"" w linku
#2) Znajdź w pliku access_log zapytania typu POST
#3) Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
#4) Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
#5) Znajdź w pliku access_log unikalne zapytania typu DELETE
#6) Znajdź unikalnych 10 adresów IP w access_log"

# Podpunkt 1
cat ./pliczki/access_log | cut -d' ' -f6,7,8 | grep '/denied'

# Podpunkt 2
cat ./pliczki/access_log | cut -d' ' -f6,7,8 | grep "\"POST"

# Podpunkt 3
cat ./pliczki/access_log | cut -d' ' -f1,6,7,8 | grep -E "^64\.242\.88\.10 "

# Podpunkt 4
temp="(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
cat ./pliczki/access_log | cut -d' ' -f1,6,7,8 | grep -Ev "^${temp}\.${temp}\.${temp}\.${temp}"

# Podpunkt 5
cat ./pliczki/access_log | cut -d' ' -f6,7,8 | grep  "\"DELETE" | sort -u

# Podpunkt 6
temp1="(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
cat ./pliczki/access_log | grep -Po "${temp1}\.${temp1}\.${temp1}\.${temp1} " | sort -u | sed 10q