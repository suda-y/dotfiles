#echo '--Loading ~/.profile--'
alias	ls='ls --color=auto --show-control-char'
alias	vi=vim
# for gettext
#export PATH="/c/Users/MSM1586/scoop/shims:$PATH"
#export PATH="/usr/local/bin:/usr/bin:/bin"
export PATH="/opt/bin:$PATH"
if [ "$LANG" = "ja_JP.SJIS" ]; then
	export	OUTPUT_CHARSET=sjis
fi
if [ "$LANG" = "ja_JP.UTF-8" ]; then
	export	OUTPUT_CHARSET=utf8
fi

