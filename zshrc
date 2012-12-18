ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

plugins=()

if [[ $(uname) = "Linux" ]]; then
	plugins+=(battery gnu-utils)
	if [[ -f /etc/arch-release ]]; then
		plugins+=(archlinux)
		if pacman -Q|grep source-highlight &> /dev/null
		then
			export LESSOPEN="| /usr/bin/source-highlight-esc.sh %s"
			export LESS=' -R '
		fi
	elif [[ -f /etc/debian_version ]]; then
		plugins+=(debian)
	fi
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"

	if [[ -f "/home/dxtr/.dircolors" ]]; then
		eval `dircolors ~/.dircolors`
	fi

	alias grep="/usr/bin/grep -n --color=auto"

	[[ "`hostname`" -eq "greger" ]] && ulimit -c unlimited >/dev/null 2>&1
elif [[ $(uname) = "FreeBSD" ]]; then
	plugins+=(gnu-utils)
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
	if [[ -f "/usr/local/bin/gls" ]] && [[ -f "/usr/local/bin/gdircolors" ]]; then
		if [[ -f "/home/dxtr/.dircolors" ]]; then
			eval `/usr/local/bin/gdircolors ~/.dircolors`
		fi
		alias ls="/usr/local/bin/gls --color=auto"
	fi
elif [[ $(uname) = "OpenBSD" ]]; then
	plugins+=()
	if [[ $TERM = "rxvt-unicode-256color" ]]; then
		export TERM=rxvt-256color
	fi
	export MANPATH=/usr/share/man
	export LC_CTYPE="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
fi

plugins+=(cpanm django extract git git-flow github nyan perl pip python urltools ssh-agent)
source $ZSH/oh-my-zsh.sh

if [[ -f "/home/dxtr/perl5/perlbrew/etc/bashrc" ]]; then
	source /home/dxtr/perl5/perlbrew/etc/bashrc
else
	export PERL_LOCAL_LIB_ROOT="/home/dxtr/perl5";
	export PERL_MB_OPT="--install_base /home/dxtr/perl5";
	export PERL_MM_OPT="INSTALL_BASE=/home/dxtr/perl5";
	export PERL5LIB="/home/dxtr/perl5/lib/perl5/armv7l-linux-thread-multi:/home/dxtr/perl5/lib/perl5";
fi

if [[ -d "/home/dxtr/go" ]]; then
	export GOPATH=~/go
fi

export GEM_HOME="/home/dxtr/.gem"

#zstyle ':completion:*' menu select=1
bindkey -e
export EDITOR=vim
alias tmux="tmux -2u"
export TZ="Europe/Stockholm"

autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on # C-x C-z
bindkey "^Z" predict-off # C-z
zstyle :predict verbose yes
zstyle :predict cursor key
zstyle ':completion:predict:*' completer _oldlist _complete _ignored _history _prefix

typeset -U path cdpath manpath fpath
