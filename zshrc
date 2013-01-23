ZSH=$HOME/.oh-my-zsh
#ZSH_THEME="dxtr-repos"
ZSH_THEME="neuromouse"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"

plugins=(ssh-agent cpanm django extract git gitfast git-extras git-flow git-remote-branch github nyan svn perl pip python urltools cp history rsync)

grep_path=$(which grep)

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

	alias grep="$grep_path --color=auto"
	alias grepn="$grep_path -n --color=auto"

	ulimit -c unlimited

	zmodload zsh/attr
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
	export OPENBSD_CVSROOT="anoncvs@anoncvs.eu.openbsd.org:/cvs"
	export LANG="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
	export PKG_PATH="ftp://ftp.eu.openbsd.org/pub/OpenBSD/snapshots/packages/amd64/"
	export PATH="$PATH:/usr/local/go/bin:/usr/games"
	export GOPATH="/usr/local/go/"

	if [[ -f "/usr/local/bin/egdb" ]]; then
		alias gdb="/usr/local/bin/egdb"
	fi
fi

source $ZSH/oh-my-zsh.sh

autoload -U predict-on zmv zrecompile tetris edit-command-line

zmodload zsh/cap zsh/clone zsh/regex zsh/zftp zsh/zpty zsh/datetime zsh/files
zmodload zsh/mathfunc zsh/net/socket zsh/net/tcp zsh/system zsh/zselect
zmodload -F zsh/stat b:zstat

zle -N predict-on
zle -N predict-off
zle -N tetris
zle -N edit-command-line

bindkey -e
bindkey "^X^Z" predict-on # C-x C-z
bindkey "^Z" predict-off # C-z
#bindkey '\ee' edit-command-line

zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*' squeeze-slashes true
#zstyle ':completion:*:default' list-prompt '%S%M matches%s'
#zstyle ':completion:*:descriptions' format "- %d -"
#zstyle ':completion:*:corrections' format "- %d - (errors %e)"
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:match:*' original only
zstyle ':completion:predict:*' completer _oldlist _ignored _history _prefix

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history
setopt interactive_comments
unsetopt beep
unsetopt hist_beep
unsetopt list_beep

zstyle :predict verbose yes
zstyle :predict cursor key

# Aliases
alias tmux="tmux -2u"
alias -s tex="vim"
alias -s txt="less"
alias -s c="vim"
alias -s cpp="vim"
alias -s html="w3m"
alias -s png="xv"
alias -s gif="xv"
alias -s jpg="xv"
alias -s pdf="xpdf"

if [[ -f "$HOME/perl5/perlbrew/etc/bashrc" ]]; then
	source $HOME/perl5/perlbrew/etc/bashrc
else
	export PERL_LOCAL_LIB_ROOT="$HOME/perl5";
	export PERL_MB_OPT="--install_base $HOME/perl5";
	export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5";
	export PERL5LIB="$HOME/perl5/lib/perl5/armv7l-linux-thread-multi:$HOME/perl5/lib/perl5";
fi

if [[ -d "$HOME/go" ]]; then
	export GOPATH=~/go:$GOPATH
	export PATH=$PATH:~/go/bin
fi

export GEM_HOME="$HOME/.gem"
export EDITOR=vim
export TZ="Europe/Stockholm"

typeset -U path cdpath manpath fpath

