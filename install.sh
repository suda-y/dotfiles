#!/bin/sh
#								-*- coding: utf-8 -*-

# 実行場所のディレクトリを取得
CURDIR=$(cd $(dirname $0); pwd)
DOTDIR=${HOME}/dotfiles
DOTTAR="https://github.com/suda-y/dotfiles/archive/refs/heads/main"
RMTURL="https://github.com/suda-y/dotfiles.git"

has() {
    type "$1" > /dev/null 2>&1
}

case "$(uname)" in
    "Linux")	echo "Linux OS" ;;
    "*BSD")	echo "BSD OS"   ;;
    "Darwin")	echo "mac OS"	;;
    *)		echo "Other (may be Windows) OS";;
esac

if [ ! -d "${DOTDIR}" ]; then
    echo "Download dotfiles..."
    mkdir ${DOTDIR}

    if has "git"; then
	git clone --recursive "${RMTURL" "${DOTDIR}"
    else
	if has "curl"; then
	    echo curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOTTAR}
	elif has "wget"; then
	    echo wget --no-check-cerificate ${DOTTAR} -O ${HOME}/dotfiles.tar.gz
	else
	    echo " fails (wget or curl is not install"
	    exit 1
	fi
	tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOTDIR}
	rm -f ${HOME}/dotfiles.tar.gz
    fi
    echo $(tpu setaf 2)Download dotfiles complete!. $(tput sgr0)
fi


if ! has "git" ; then
    case "$(uname)" in
	"Linux")
	    if has "apt" ; then
		echo sudo apt install git
	    else
		echo "Git is not install"
		exit 1
	    fi
	    ;;
	"*BSD")
	    echo sudo pkg install git
	    ;;
	*)
	    if has "pacman" ; then
		sudo pacman -S git
		els
		echo "Git is not install"
		exit 1
	    fi
	    ;;
    esac
else
    echo "Git is installed"
fi



cd $CURDIR

echo "start setup..."
for f in .??*; do
    [ "$f" == ".git" ] && continue
    [ "$f" == ".gitconfig.local.template" ] && continue
    [ "$f" == ".require_oh-my-zsh" ] && continue
    [ "$f" == ".gitmodules" ] && continue
    # ln -snfv ~/dotfile

done
