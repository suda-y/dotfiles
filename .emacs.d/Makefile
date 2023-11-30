# -*- mode: makefile -*-
EMACS	?= emacs

EL	= early-init.el 	# w32-symlinks.el
ELC	= $(EL:%.el=%.elc)

all:	$(ELC) init.elc

$(EL):	init.el
init.el early-init.el:	INIT.org
	$(EMACS) -Q -q --batch --eval \
	  "(progn \
	    (require 'ob-tangle) \
	    (org-babel-tangle-file \"$<\" \"$@\" \"emacs-lisp\"))"
	$(EMACS) -q -l init.el --batch --eval '(kill-emacs)'
%.elc:	%.el
	$(EMACS) -q -l init.el --batch -f batch-byte-compile $<

clean:
	rm -rf auto-save-list custom.el *.elc *~

