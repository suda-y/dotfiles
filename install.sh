#!/usr/bin/env bash
set -e
OS=$(uname -s)
DOTDIR="${HOME}/dotfiles"
DOTTAR="https://github.com/suda-y/dotfiles/tarball/main"
RMTURL="https://github.com/suda-y/dotfiles.git"
backup=false

has() {
  type "$1" > /dev/null 2>&1
}

usage() {
  name=$(basename $0)
  cat <<EOF
Usage:
  $name [arguments] [command]

Commands:
  deploy
  initialize

Arguments:
  -f $(tput setaf 1)** warngin ***$(tput sgr0) Overwrie dotfiles.
  -h Print help (this messsage)
EOF
  exit 1
}

while getopts :bdfh-: OPT; do
  optarg="$OPTARG"
  [[ "$OPT" = - ]] &&
    OPT="-${OPTARG%%=*}" &&
    optarg="${OPTARG/${OPTARG%%=*}/}" &&
    optarg="${optarg#=}"
  case "-$OPT" in
    -b|--backup) backup=true ;;
    -f|--force) OVERWRITE=true ;;
    -h|--help)  usage ;;
    -d|--debug)
      set -uex
      ;;
    --)
      break ;;
    -\?)
      exit 1 ;;
    --*)
      echo "$OPTARGは定義されていません (OPT=$OPT) "
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# If mmissing, download and extract the dotfiles repository
if [ ! -d ${DOTDIR} ]; then
  mkdir ${DOTDIR}

  if has "git"; then
    git clone --recursive "${RMTURL}" "${DOTDIR}"
  else
    if  has "curl"; then
      curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOTTAR}
    elif has "wget"; then
      wget -qO ${HOME}/dotfiles.tar.gz ${DOTTAR}
    else
      echo "Please install git or curl"
      exit 1
    fi
    tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOTDIR}
    rm -f ${HOME}/dotfiles.tar.gz
  fi

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
    echo "Install pacman(msys) packages..."

    pacman -S openssl-devel

    echo "$(tput setaf 2)Install pacman(msys) packages complete.✓$(tput sgr0)"
  fi
}

run_go() {
  if has "go"; then
    echo "Install go packages..."

    go get -u golang.org/x/tools/gopls
    go get -u golang.org/x/tools/cmd/goomports

    echo "$(tput setaf 2)Install go packages complete.✓$(tput sgr0)"
  fi
}

run_node() {
  if has "npm"; then
    echo "Install npm packages..."

    npm install -g \
	node-gyp \
	coffeescript \
	eslint \
	http-server \
	node-google-apps-script \
	prettier \
	tern \
	tldr \
	tslint \
	typescript \
	typings \
	uglify-js \
	uglifycss

    echo "$(tput setaf 2)Install npm packages complete.✓$(tput sgr0)"
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
      run_apt ;;
    msys)
      run_pacman ;;
    *)
      echo "$(tput setaf 1)Working only Linux!!$(tput sgr0) (OSTYPE=${OSTYPE})"
      exit 1 ;;
  esac

  set +e
  run_go
  run_node
  set -e

  echo $(tput setaf 2)Initialize complete!✓ $(tput sgr0)
}

if [ $# -gt 0 ]; then
  command=$1
  shift
else
  command=""
fi

case $command in
  deploy)
    link_files
    ;;
  init*)
    initialize
    ;;
  *)
    usage ;;
esac

exit 0
