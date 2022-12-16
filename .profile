#echo '--Loading ~/.profile--'
alias	ls='ls --color=auto --show-control-char'
alias	vi=vim
# for gettext
if [ -d "/c/Users/MSM1586/scoop/shims" ]; then
	export PATH="/c/Users/MSM1586/scoop/shims:$PATH"
fi
if [ -d "/opt/bin" ]; then
	export PATH="/opt/bin:$PATH"
fi
if [ -d "/usr/local" ]; then
	export PATH="/usr/local/bin:/usr/bin:/bin:${PATH}"
	export MANPATH="/usr/local/share/man:${MANPATH}"
	export INFOPATH="/usr/local/share/info:${INFOPATH}"
fi
if [ "$LANG" = "ja_JP.SJIS" ]; then
	export	OUTPUT_CHARSET=sjis
fi
if [ "$LANG" = "ja_JP.UTF-8" ]; then
	export	OUTPUT_CHARSET=utf8
fi

