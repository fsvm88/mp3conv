#!/bin/bash

#Prototype: find_mp3s out_filename
function find_mp3s () {
	find . -name "*\.mp3" -type "f" > "${1}"
}

#Prototype: find_dirs out_filename
function find_dirs () {
	find . -name "*" -type "d" > "${1}"
}

#Prototype: generate_list_of_files in_dir mp3_file dirs_file
function generate_list_of_files () {
	cd "${1}"
	find_mp3s "${2}"
	find_dirs "${3}"
	cd "${HOME_DIR}"
}