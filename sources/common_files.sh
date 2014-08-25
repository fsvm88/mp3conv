#!/bin/bash

function remove_files () {
	rm -f ${1}
}

#Prototype: remove_file files_to_remove
function remove_file () {
	rm -f "${1}"
}

#Prototype: move_file src dst
function move_file () {
	mv "${1}" "${2}"
}

#Prototype: create_dir dir_name
function create_dir () {
	echo "Creating dir ${1}"
	mkdir -p "${1}"
}

#Prototype: ensure_dir_existance dir_name
function ensure_dir_existance () {
	if [[ ! -d "${1}" ]]; then
		create_dir "${1}"
	fi
}

#Prototype: replicate_dir_structure dir_name dirs_list
function replicate_dir_structure () {
	echo "Replicating directory structure into ${1}"
	while read directory; do
		ensure_dir_existance "${1}${directory}"
	done < "${2}"
}

#Prototype: update_screen cur_file tot_file filename
function update_screen () {
	printf "File %d/%d, %s\r" "$1" "$2" "$3"
}

#Prototype: print_error failed_filename errors_file
function print_error () {
	echo "$1" >> "${2}"
}