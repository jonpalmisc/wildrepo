#!/bin/sh

COLOR_RED="$(tput -Txterm setaf 1)"
COLOR_GREEN="$(tput -Txterm setaf 2)"
COLOR_RESET="$(tput -Txterm sgr0)"

TOKEN_FILE=TOKEN.txt

PATTERN_FILE=patterns.txt
MANIFEST_FILE=manifest.txt

if [ -z "$SKIP_MANIFEST" ]; then
	echo "${COLOR_GREEN}Updating manifest...${COLOR_RESET}"
	if ! WILDREPO_TOKEN="$(cat $TOKEN_FILE)" xargs wildrepo <$PATTERN_FILE >$MANIFEST_FILE; then
		echo "${COLOR_RED}Error: Failed to update manifest.${COLOR_RESET}"
		exit 1
	fi
fi

wildclone <$MANIFEST_FILE
