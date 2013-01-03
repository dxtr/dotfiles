ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"

plugins=()

export LC_CTYPE="en_US.UTF-8"

if [[ $(uname) = "Linux" ]]; then
	plugins+=(battery gnu-utils)
	if [[ -f /etc/arch-release ]]; then
		plugins+=(archlinux systemd)
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

	if [[ -f "$HOME/.dircolors" ]]; then
		eval `dircolors ~/.dircolors`
	fi

	alias grep="$(which grep) -n --color=auto"

	ulimit -c unlimited
elif [[ $(uname) = "FreeBSD" ]]; then
	plugins+=(gnu-utils)
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
	if [[ -f "/usr/local/bin/gls" ]] && [[ -f "/usr/local/bin/gdircolors" ]]; then
		if [[ -f "$HOME/.dircolors" ]]; then
			eval `/usr/local/bin/gdircolors ~/.dircolors`
		fi
		alias ls="/usr/local/bin/gls --color=auto"
	fi
elif [[ $(uname) = "OpenBSD" ]]; then
	plugins+=()
	if [[ $TERM = "rxvt-unicode-256color" ]]; then
		export TERM=rxvt-256color
	fi
	export MANPATH="/usr/share/man:/usr/X11R6/man:/usr/local/man"
	export LC_CTYPE="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
	export PKG_PATH="ftp://ftp.eu.openbsd.org/pub/OpenBSD/snapshots/packages/amd64/"
fi

plugins+=(ssh-agent cpanm django extract git gitfast git-extras git-flow git-remote-branch github nyan svn perl pip python urltools cp history rsync)
source $ZSH/oh-my-zsh.sh

if [[ -f "$HOME/perl5/perlbrew/etc/bashrc" ]]; then
	source $HOME/perl5/perlbrew/etc/bashrc
else
	export PERL_LOCAL_LIB_ROOT="$HOME/perl5";
	export PERL_MB_OPT="--install_base $HOME/perl5";
	export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
	export PERL5LIB="$HOME/perl5/lib/perl5/armv7l-linux-thread-multi:$HOME/perl5/lib/perl5";
fi

if [[ -d "$HOME/go" ]]; then
	export GOPATH=~/go
fi

export GEM_HOME="$HOME/.gem"

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
