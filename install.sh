#!/usr/bin/env bash
set -e

VERSION=1.0

DOTDIR="${HOME}/dotfiles"
DOTTAR="https://github.com/suda-y/dotfiles/tarball/main"
RMTURL="https://github.com/suda-y/dotfiles.git"

usage() {
  name=$(basename $0)
  cat <<EOF
Usage:
  $name [arguments] [command]

Commands:
  deploy
  initialize

Arguments:
  -v print version number.
  -f $(tput setaf 1)** warngin ***$(tput sgr0) Overwrie dotfiles.
  -h Print help (this messsage)
EOF
  >&2
  exit 1
}

abort() { echo "$*" >&2; exit 1; }
unknown() { abort "認識されていないオプション '$1''"; }
has() { type "$1" > /dev/null 2>&1; }

OVERWRITE=''
DEBUG_FLG=''

while getopts :dfhv-: OPT; do
  optarg="$OPTARG"
  [[ "$OPT" = - ]] && OPT="-${OPTARG%%=*}"
  case "-$OPT" in
      -f|--force)
	  OVERWRITE=true ;;
      -v|--version)
	  abort "$(basename $0) v$VERSION" ;;
      -h|--help)
	  usage ;;
      -d|--debug)
	  set -uex ;;
      -\?)
	  unknown "$@" ;;
      *)
	  abort "$OPTARGは定義されていません (OPT=$OPT) " ;;
  esac
done
shift $((OPTIND - 1))

# If mmissing, download and extract the dotfiles repository
if has "git"; then
    if [ ! -d "$DOTDIR" ]; then
	git clone --recursive "${RMTURL}" "${DOTDIR}"
    elif [ -n "$OVERWRITE" ]; then
	cd ${DOTDIR}
	git pull
    else
	echo "$(tput setaf 2)Always update dotfiles.$(tput sgr0)"
    fi
else
    if  has "curl"; then
	curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOTTAR}
    elif has "wget"; then
	wget -qO ${HOME}/dotfiles.tar.gz ${DOTTAR}
    else
	abort "Please install curl, wget or git."
    fi
    if [ ! -d ${DOTDIR} -o -n "$OVERWRITE" ]; then
	tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOTDIR}
	echo "Overwrite update !"
    fi
    rm -f ${HOME}/dotfiles.tar.gz
    echo $(tput setaf 2)Download dotfiles complete!✓ $(tput sgr0)
fi

run_apt() {
  echo "Installing Packages..."

  sudo apt update && sudo apt upgrade -y
  [[ $? ]] && echo "$(tput setaf 2)Update Packages complete.✓$(tput sgr0)"

  local list_formulae
  local -a missing_formulae
  local -a desired_formulae=(
    'autoconf'
    'automake'
    'emacs'
    'gcc'
    'gettext'
    'git'
    'imagemagick'
    'libssl-dev'
    'libbz2-dev'
    'nkf'
    'openssl'
  )

  local installed=$(apt list --installed >&1 | grep -v deinstall | awk -F/ '{print $1}')

  for index in ${!desired_formulae[*]}; do
    local formula=`echo ${desired_formulae[$index]} | cut -d' ' -f 1`
    if [[ -z `echo "${installed}" | grep "^${formula}$"` ]]; then
      missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
    else
      echo "Installed ${formula}"
    fi
  done

  if [[ "${missing_formulae}" ]]; then
    list_formulae=$( printf "%s " "${missing_formulae[@]}" )

    echo "Installing missing packages formulae..."
    sudo apt install -y $list_formulae

    [[ $? ]] && echo "$(tput setaf 2)Installed missing formulae ✓$(tput sgr0)"
  fi
}

run_pacman() {
    if has "pacman"; then
	echo "Installing Packages..."

	# pacman -Syu --disable-download-timeout
	# [[ $? ]] && echo "$(tput setaf 2)Update Packages complete.✓$(tput sgr0)"
	
	local list_formulae
	local -a missing_formulae
	local -a desired_formulae=(
	    'mingw-w64-x86_64-emacs'
	    'mingw-w64-x86_64-ruby'
	    'ruby'
	)
      
	local installed=$(env LANG=C pacman -Sl >&1 | grep installed | awk '{print $2}')

	for index in ${!desired_formulae[*]}; do
	    # local formula=$(echo ${desired_formulae[$index]} | cut -d' ' -f 1)
	    local formula=$(echo ${desired_formulae[$index]})
	    if [[ -z $(echo "${installed}" | grep "^${formula}$") ]]; then
		missing_formulae=("${missing_formulae[@]}" "${desired_formulae[$index]}")
	    else
		echo "Installed ${formula}"
	    fi
	done

	if [[ "${missing_formulae}" ]]; then
	    list_formulae=$(printf "%s " "${missing_formulae[@]}")

	    echo "Installing missing packages formulae..."
	    echo pacman -S $list_formulae
	    
	    [[ $? ]] && echo "$(tput setaf 2)Install missing formulae.✓$(tput sgr0)"
	fi
    fi
}

link_files() {
  cd ${DOTDIR}
  for f in .??*; do
    [[ ${f} = ".git" ]] && continue
    [[ ${f} = ".gitignore" ]] && continue
    [[ ${f} = ".profile" ]] && continue
    if [ -e ${HOME}/${f} -a -n "${OVERWRITE}" ]; then
      echo rm -f ${HOME}/${f}
    fi
    if [ ! -e ${HOME}/${f} ]; then
      # If you have ignore files, and file/directory name here
      echo ln -snfv ${DOTDIR}/${f} ${HOME}/${f}
    else
      echo "No link. ${f}"
    fi
  done 
  echo $(tput setaf 2)Deploy dotfiles complete!✓ $(tput sgr0)
}

initialize() {
    case ${OSTYPE} in
	linux-gnu)
	    run_apt
	    ;;
	msys)
	    run_pacman
	    ;;
	*)
	    echo "$(tput setaf 1)Working only Linux!!$(tput sgr0) (OSTYPE=$OSTYPE}"
	    exit 1
	    ;;
    esac

    echo $(tput setaf 2)Initialize complete!✓ $(tput sgr0)
}

while [ $# -gt 0 ]; do
    case $1 in
	deploy) link_files; exit 0 ;;
	initi*) initialize; exit 0 ;;
	*) usage; exit 1 ;;
    esac
    shift
done

exit 0
