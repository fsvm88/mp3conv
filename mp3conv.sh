#!/bin/bash

. /etc/init.d/functions.sh

HOME_DIR="/mnt/storage/musicatoreconv"
IN_DIR="${HOME_DIR}/toreconv"
CONV_DIR="${HOME_DIR}/reconv"
GAIN_DIR="${HOME_DIR}/gained"
MP3_LIST_FILE="${HOME_DIR}/mp3s"
DIRS_LIST_FILE="${HOME_DIR}/dirs"
DIRS_TO_REPLICATE_FILE="${HOME_DIR}/dirs_torepl"
ERROR_FILE="${HOME_DIR}/reconv_errors"
TEMP_FILES="${MP3_LIST_FILE} ${DIRS_LIST_FILE} ${DIRS_TO_REPLICATE_FILE}"

BASE_LAME_COMMAND="lame -m j -q 0 --vbr-new -V 0 -b 32 -B 320 --resample 44.1"
BASE_MP3GAIN_COMMAND="mp3gain -d 89 -r -o -s r -p -k"

#Includes
. ./sources/common_files.sh
. ./sources/lists.sh
. ./sources/finds.sh
. ./sources/execs.sh

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#MAIN SECTION OF THE PROGRAM
#Below we can modify program flow
#Functions ONLY above
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Cleanup temp files for run
remove_files "${TEMP_FILES} ${ERROR_FILE}"
#Check if output directories exist, else create them
ensure_dir_existance "${CONV_DIR}"
ensure_dir_existance "${GAIN_DIR}"

echo "Generating list (MP3, dirs) for reconversion"
generate_list_of_files "${IN_DIR}" "${MP3_LIST_FILE}" "${DIRS_LIST_FILE}"
#Reformats the lists for better use
wrap_list_reformat "${MP3_LIST_FILE}" "${DIRS_LIST_FILE}" "${DIRS_TO_REPLICATE_FILE}"

#checkpoint
#Replicates directory structure for reconversion and converts the files
replicate_dir_structure "${CONV_DIR}" "${DIRS_TO_REPLICATE_FILE}"
convert_files "${IN_DIR}" "${CONV_DIR}" "${MP3_LIST_FILE}"

#Cleanup dirs,
remove_file "${DIRS_LIST_FILE} ${DIRS_TO_REPLICATE_FILE}"

echo "Generating list (MP3, dirs) for gain applying"
generate_list_of_files "${CONV_DIR}" "${MP3_LIST_FILE}" "${DIRS_LIST_FILE}"
#Reformats the lists for better use
wrap_list_reformat "${MP3_LIST_FILE}" "${DIRS_LIST_FILE}" "${DIRS_TO_REPLICATE_FILE}"

#Replicates directory structure for reconversion and applies gains to files
replicate_dir_structure "${GAIN_DIR}" "${DIRS_TO_REPLICATE_FILE}"
apply_gains  "${CONV_DIR}" "${GAIN_DIR}" "${MP3_LIST_FILE}"

sanitize_tags "${GAIN_DIR}/"

remove_files "${TEMP_FILES}"

echo "Everything done. Files are found in ${GAIN_DIR}"
