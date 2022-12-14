#!/bin/bash
#								-*- coding: utf-8 -*-

set -Ceuxo pipefail

download() {
    if [ -d "${dotfiles_path}" ]; then
	echo "ngmy/dotfiles already exists in '${dot_files_path}'"
	local lyn
	read -p 'Do you  want to re-download ngmy/dotfiles and continue the installation ? (y/N)' yn
	if [ "${yn}" != "y" ]; then
	    echo 'The installaation was canceled.'
	    exit 1
	fi
	echo "Downloading ngmy/dotfiles to '${dotfiles_path}'..."
	# git -C "${dotfiles_path}" pull origin master
	# git -C "{dotfiles_path}" submodule update
    else
	echo "Downloading ngmy/dotfiles to '${dotfiles_path}'..."
	# git clone https://github.com/suda/dotfiles.git "${dotfiles_path}"
	# git -C "${dotfiles_path}" pull origin master
	# git -C "{dotfiles_path}" submodule update
    fi
}

main() {
    local -r dotfiles_path="$(realpath "${1:-"${HOME}/dotfiles"}")"

    download
}

main "$@"
