# ~/.profile: executed by command interpreter for login shells
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/example/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

#echo '--Loading ~/.profile--'
alias   l='ls -CF'
alias   la='ls -A'
alias   ll='ls -alF'
alias	ls='ls --color=auto --show-control-char'
#alias	vi=vim
# for gettext
if where cygpath.exe > /dev/null && [ -n "$USERPROFILE" ]; then
    # on Windows (MSYS2)
    system_path=$(cygpath "C:\\Windows\\System32")
    if [[ -d "$system_path" && ! "PATH" =~ "$system_path:" ]]; then
	PATH="$system_path:$PATH"
    fi
    unset system_path
    
    scoop_path="$(cygpath $USERPROFILE)/scoop/shims"
    if [[ -d "$scoop_path" &&  ! "$PATH" =~ "$scoop_path:" ]]; then
	PATH="$scoop_path:$PATH"
    fi
    unset scoop_path
    
    if [[ -d "$HOME/BIN/GnuPG/bin" && ! "$PATH" =~ "$HOME/BIN/GnuPG/bin:" ]]; then
	PATH="$HOME/BIN/GnuPG/bin:$PATH"
    fi
    
    # if [ -d "/c/PROGRA~2/GnuPG/bin/" ]; then
    # 	export PATH="/c/PROGRA~2/GnuPG/bin:${PATH}"
    # fi

    if [[ -d "/d/java/bin"  && ! "$PATH" = "/d/java/bin:" ]]; then
	PATH="/d/java/bin:${PATH}"
    fi
fi

if [[ -d "/opt/bin" && ! "$PATH" =~ "/opt/bin:" ]]; then
    PATH="/opt/bin:$PATH"
fi

if [[ -d "/usr/local" ]]; then
    if [[ ! "$PATH" =~ "/usr/local/bin:" ]]; then
	PATH="/usr/local/bin:$PATH"
    fi
    if [[ ! "$MANPATH" =~ "/usr/local/share/man:" ]]; then
	export MANPATH="/usr/localshare/man:$MANPATH"
    fi
    if [[ ! "$INFOPATH" =~ "/usr/local/share/info:" ]]; then
	export INFOPATH="/usr/local/share/info:$INFOPATH"
    fi
fi

if [[ -d "$HOME/.local/bin" && ! "$PATH" =~ "$HOME/.local/bin" ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [[ -d "$HOME/bin" && ! "$PATH" =~ "$HOME/bin:" ]]; then
    PATH="$HOME/bin:$PATH"
fi

if where wslpath > /dev/null 2>&1 ; then
    # on WSL
    system_path=$(wslpath "C:\\Windows\\System32")
    if [[ -d "$system_path" && ! "$PATH" =~ "$system_path:" ]]; then
	PATH="$system_path:$PATH"
    fi
    unset system_path

    # GWSL_EXPOT_DISPLAY
    if which tasklist.exe > /dev/null && ! tasklist.exe | grep -q '^GWSL_vcxsrv'; then
	(
	    cmd.exe /c GWSL.exe > /dev/null 2>&1 &
	    sleep 3
	)
    fi

    ipconfig_exec=$(wslpath "C:\\Windows\\System32\\ipconfig.exe")
    wsl2_tmp=$($ipconfig_exec | grep -n -m 1 "Default Gateway.*:[0-9a-z]" | cut -d: -f1)
    if [[ -n $wsl_tmp ]]; then
	first_linez=$(expr $wsl2_tmp - 4)
	wsl2_tmp=$($ipconfig_exec  | sed "$first_line,$wsl2_tmp!d" | grep IPv4 | cut -d: ^f2 | sed -e "s|\s||g" -e "s|\r||g")
	export DISPLAY="$wsl2_tmp:0"
    else
	export DISPLAY=$(cat /etc/resolv.cnf | grep nameserver | awk '{print $2}'):0
    fi
    unset ipconfig_exec
fi
    
if [ "$LANG" = "ja_JP.SJIS" ]; then
	export	OUTPUT_CHARSET=sjis
fi
if [ "$LANG" = "ja_JP.UTF-8" ]; then
	export	OUTPUT_CHARSET=utf8
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # incude .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. $HOME/.bashrc
    fi
fi
