#!/bin/sh

# Emacs の設定
[ ! -d ~/.emacs.d ] && mkdir ~/.emacs.d
for f in ${PWD}/dot.emacs.d/* ; do
	ln -sf ${f} ~/.emacs.d/
done

# w3m
[ ! -d ~/.w3m ] && mkdir ~/.w3m
ln -sf ${PWD}/dot.w3m/bootkmark.html ~/.w3m/
ln -sf ${PWD}dot.profile ~/.profile
