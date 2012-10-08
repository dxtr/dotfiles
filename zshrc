

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

if [[ $(uname) = "Linux" ]]; then
	if [[ -f /etc/arch-release ]]; then
		plugins=(archlinux battery cpanm debian django extract git git-flow github gnu-utils nyan osx perl pip python ssh-agent)
	elif [[ -f /etc/debian_version ]]; then
		plugins=(battery cpanm debian django extract git git-flow github gnu-utils nyan perl pip python)
	else
		plugins=(battery cpanm django extract git git-flow github gnu-utils nyan perl pip python)
	fi
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"

	if [[ -f "/home/dxtr/.dircolors" ]]; then
		eval `dircolors ~/.dircolors`
	fi
elif [[ $(uname) = "FreeBSD" ]]; then
	plugins=(cpanm django extract git git-flow github gnu-utils nyan perl pip python)
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
	if [[ $TERM = "rxvt-unicode-256color" ]]; then
		export TERM=rxvt-256color
	fi
	export MANPATH=/usr/share/man
	export LC_CTYPE="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
	plugins=(cpanm django extract git git-flow github nyan perl pip python)
fi

source $ZSH/oh-my-zsh.sh
#PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH:/home/dxtr/bin"

if [[ -f "/home/dxtr/perl5/perlbrew/etc/bashrc" ]]; then
	source /home/dxtr/perl5/perlbrew/etc/bashrc
else
	export PERL_LOCAL_LIB_ROOT="/home/dxtr/perl5";
	export PERL_MB_OPT="--install_base /home/dxtr/perl5";
	export PERL_MM_OPT="INSTALL_BASE=/home/dxtr/perl5";
	export PERL5LIB="/home/dxtr/perl5/lib/perl5/armv7l-linux-thread-multi:/home/dxtr/perl5/lib/perl5";
	export PATH="/home/dxtr/perl5/bin:$PATH";
fi

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
