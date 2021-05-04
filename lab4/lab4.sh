#!/bin/bash -eu

function print_help () {
    echo "This script allows to search over movies database"
    echo -e "-d DIRECTORY\n\tDirectory with files describing movies"
    echo -e "-a ACTOR\n\tSearch movies that this ACTOR played in"
    echo -e "-t QUERY\n\tSearch movies with given QUERY in title"
    echo -e "-y YEAR\n\Find movies released after a given YEAR"
    echo -e "-f FILENAME\n\tSaves results to file (default: results.txt)"
    echo -e "-x\n\tPrints results in XML format"
    echo -e "-h\n\tPrints this help message"
}

function print_error () {
    echo -e "\e[31m\033[1m${*}\033[0m" >&2
}

function get_movies_list () {
    local -r MOVIES_DIR=${1}
    local -r MOVIES_LIST=$(cd "${MOVIES_DIR}" && realpath ./*)
    echo "${MOVIES_LIST}"
}

function query_title () {
    # Returns list of movies from ${1} with ${2} in title slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Title" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

function query_actor () {
    # Returns list of movies from ${1} with ${2} in actor slot
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Actors" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE}" )
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

#+ 1.0: Dodaj opcję -y ROK: wyszuka wszystkie filmy nowsze niż ROK.
function query_year () {
    local -r MOVIES_LIST=${1}
    local -r QUERY=${2}

    local RESULTS_LIST=()
    for MOVIE_FILE in ${MOVIES_LIST}; do
        if grep "| Year" "${MOVIE_FILE}" | grep -q "${QUERY}"; then
            RESULTS_LIST+=( "${MOVIE_FILE} ")
        fi
    done
    echo "${RESULTS_LIST[@]:-}"
}

# + 0.5: Dotyczy opcji ‘-f’: jeżeli plik podany przez użytkownika nie posiada rozszerzenia '.txt' dodaj je
function check_if_txt (){

    if [[ ${1: -4} != ".txt" ]]; then
        local add_txt="${1}.txt"
        echo "${add_txt}"
    else
        echo "${1}"
    fi      
}

#+1.0:  Dokończ funkcję “print_xml_format”
function print_xml_format () {
    local -r FILENAME=${1}
    local TEMP
    TEMP=$(cat "${FILENAME}")

    # TODO: replace first line of equals signs
    TEMP=${TEMP//=====================================================/<movie>}
    # TODO: change 'Author:' into <Author>
	TEMP=${TEMP//| Author:/<Author>}
    # TODO: change others too
    TEMP=${TEMP//| Title:/<Title>}
    TEMP=${TEMP//| Year:/<Year>}
    TEMP=${TEMP//| Runtime:/<Runtime>}
    TEMP=${TEMP//| IMDB:/<IMDB>}
    TEMP=${TEMP//| Tomato:/<Tomato>}
    TEMP=${TEMP//| Rated:/<Rated>}
    TEMP=${TEMP//| Genre:/<Genre>}
    TEMP=${TEMP//| Director:/<Director>}
    TEMP=${TEMP//| Actors:/<Actors>}
    TEMP=${TEMP//| Plot:/<Plot>}


    # append tag after each line
    TEMP=$(echo "${TEMP}" | sed -r 's/([A-Za-z]+).*/\0<\/\1>/')

    # replace the last line with </movie>
    TEMP=$(echo "${TEMP}" | sed '$s/===*/<\/movie>/')

    echo "${TEMP}"
}

function print_movies () {
    local -r MOVIES_LIST=${1}
    local -r OUTPUT_FORMAT=${2}

    for MOVIE_FILE in ${MOVIES_LIST}; do
        if [[ "${OUTPUT_FORMAT}" == "xml" ]]; then
            print_xml_format "${MOVIE_FILE}"
        else
            cat "${MOVIE_FILE}"
        fi
    done
}


while getopts ":hd:t:a:f:x:y" OPT; do
  case ${OPT} in
    h)
        print_help
        exit 0
        ;;
    d)
        MOVIES_DIR=${OPTARG}
        ;;
    t)
        SEARCHING_TITLE=true
        QUERY_TITLE=${OPTARG}
        ;;
    f)
        fixedTXT=$( check_if_txt "${OPTARG}" ) 
        FILE_4_SAVING_RESULTS=${fixedTXT}
        ;;
    a)
        SEARCHING_ACTOR=true
        QUERY_ACTOR=${OPTARG}
        ;;
    y)
        SEARCHING_YEAR=true
        QUERY_YEAR=${OPTARG}
        ;;
    x)
        OUTPUT_FORMAT="xml"
        ;;
    \?)
        print_error "ERROR: Invalid option: -${OPTARG}"
        exit 1
        ;;
  esac
done

# + 0.5: Dodaj sprawdzenie, czy na pewno wykorzystano opcję '-d' i czy jest to katalog
if [[ -d ${MOVIES_DIR} ]]; then

    MOVIES_LIST=$(get_movies_list "${MOVIES_DIR}")

    if ${SEARCHING_TITLE:-false}; then
        MOVIES_LIST=$(query_title "${MOVIES_LIST}" "${QUERY_TITLE}")
    fi

    if ${SEARCHING_ACTOR:-false}; then
        MOVIES_LIST=$(query_actor "${MOVIES_LIST}" "${QUERY_ACTOR}")
    fi

    if ${SEARCHING_YEAR:-false}; then
        MOVIES_LIST=$(query_year "${MOVIES_LIST}" "${QUERY_YEAR}")
    fi
	
	if [[ "${#MOVIES_LIST}" -lt 1 ]]; then
        echo "Found 0 movies :-("
        exit 0
    fi

    if [[ "${FILE_4_SAVING_RESULTS:-}" == "" ]]; then            
        print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT:-raw}"
    else       
        # TODO: add XML option             
        print_movies "${MOVIES_LIST}" "${OUTPUT_FORMAT}" | tee "${FILE_4_SAVING_RESULTS}"
    fi
else
	echo "Incorrect directory."
fi