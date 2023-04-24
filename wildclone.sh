#!/bin/sh

COLOR_RED="$(tput -Txterm setaf 1)"
COLOR_GREEN="$(tput -Txterm setaf 2)"
COLOR_YELLOW="$(tput -Txterm setaf 3)"
COLOR_RESET="$(tput -Txterm sgr0)"

NO_ERRORS=true

log() {
	echo "${COLOR_GREEN}$1${COLOR_RESET}"
}

log_warn() {
	echo "${COLOR_YELLOW}$1${COLOR_RESET}"
}

log_error() {
	echo "${COLOR_RED}$1${COLOR_RESET}"
	NO_ERRORS=false
}

# Ensure some form of input was provided.
if [ -t 0 ]; then
	printf "%s\n\n" "Error: No input; a list of repository URLs must be given via standard input."

	echo "Examples:"
	echo "  wildrepo 'apple/lib*' | wildclone"
	echo "  wildclone < repos.txt"
	exit 1
fi

while read -r ssh_url; do
	repo="${ssh_url#*:}"
	repo="${repo%.git}"

	# If the repo folder doesn't exist, it is assumed it has never been
	# cloned before.
	if ! [ -d "$repo" ]; then
		# Since repos are typically organized by owner, a parent
		# directory for the owning entity will also need to be created
		# first for the clone to work.
		#
		# This will of course create the directory for the repo itself
		# as well, but that is fine; Git will only complain if the
		# directory is not empty.
		mkdir -p "$repo"

		log "Making local copy of $repo..."
		if ! git clone --bare "$ssh_url" "$repo"; then
			log_error "Error: Failed to clone $repo."
			continue
		fi

		continue
	fi

	# If the directory does exist, it is assumed that some version of the
	# repo is present locally and just needs to be synced with the remote.
	log "Syncing local copy of $repo..."
	if ! GIT_DIR="$repo" git --bare fetch --all --tags; then
		log_error "Error: Failed to sync local copy of $repo."
		continue
	fi
done

if ! "$NO_ERRORS"; then
	log_warn "Warning: Not all operations completed successfully."
	exit 1
fi

log "All operations completed successfully."
