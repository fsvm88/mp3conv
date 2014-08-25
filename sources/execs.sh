#!/bin/bash

#Includes
. ./sources/common_files.sh

#Prototype: really_convert_file in_filename out_filename
function really_convert_file () {
	$BASE_LAME_COMMAND "${1}" "${2}" &> /dev/null
	return $?
}

#Prototype: really_apply_gain file_to_gain
function really_apply_gain () {
	$BASE_MP3GAIN_COMMAND "${1}" &> /dev/null
	return $?
}

#Prototype: convert_files in_dir conv_dir mp3_file
function convert_files () {
	echo "Converting files"
	COUNTER=1
	FILE_NUMBER=`wc -l "${3}" | sed 's: .*::g'`
	while read filetoreconv; do
		update_screen "$COUNTER" "$FILE_NUMBER" "$filetoreconv"
		really_convert_file "${1}${filetoreconv}" "${2}${filetoreconv}"
		CODE=$?
		if [[ $CODE -ne 0 ]]; then
			print_error "$filetoreconv (code $CODE)" "${ERROR_FILE}"
		fi
		if [[ $CODE -eq 0 ]]; then
			remove_file "${1}${filetoreconv}"
		fi
		let COUNTER++
	done < "${3}"
}

#Prototype: apply_gains conv_dir gain_dir mp3_file
function apply_gains () {
	echo "Applying gain to all converted files"
	COUNTER=1
	FILE_NUMBER=`wc -l "${3}" | sed 's: .*::g'`
	while read filetoreconv; do
		update_screen "$COUNTER" "$FILE_NUMBER" "$filetoreconv"
		really_apply_gain "${1}${filetoreconv}"
		CODE=$?
		if [[ $CODE -ne 0 ]]; then
			print_error "$filetoreconv (code $CODE)" "${ERROR_FILE}"
		fi
		if [[ $CODE -eq 0 ]]; then
			move_file "${1}${filetoreconv}" "${2}${filetoreconv}"
		fi
		let COUNTER++
	done < "${3}"
}

#Prototype: sanitize_tags gain_dir
function sanitize_tags () {
	echo -e "Sanitizing tags\n"
	eyeD3 -v2 --to-v2.4 --remove-comments --remove-lyrics --remove-v1 --force-update "${1}" &> /dev/null
	eyeD3 -v2 --remove-comments --remove-lyrics --remove-v1 --force-update --set-encoding=utf8 "${1}" &> /dev/null
	echo "Tag sanitization done."
}