#!/bin/bash

#Prototype: format_list list_name
function format_list () {
	sed -e 's:^\.::g' -e 's: :\\ :g' -i "${1}"
}

#Prototype: spot_dirs_to_repl mp3s_dir dirs_list final_dir_list
function spot_dirs_to_repl () {
	while read linea; do
		if [[ "`fgrep "${linea}" "${1}"`" != "" ]]; then
			echo "${linea}" >> "${3}"
		fi
	done < "${2}"
}

#Prototype: wrap_list_reformat mp3_file in_dir_file out_dir_file
function wrap_list_reformat () {
	if [[ -f "${1}" && -f "${2}" ]]; then
		echo "Formatting lists"
		spot_dirs_to_repl "${1}" "${2}" "${3}"
		if [[ -f "${3}" ]]; then
			format_list "${1}"
			format_list "${3}"
		else
			exit 1
		fi
	else
		exit 1
	fi
}