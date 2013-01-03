ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

plugins=()

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
	export MANPATH=/usr/share/man
	export LC_CTYPE="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
fi

plugins+=(cpanm django extract git gitfast git-extras git-flow git-remote-branch github nyan svn perl pip python urltools ssh-agent cp history rsync)
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
export EDITOR=vim
export TZ="Europe/Stockholm"

autoload -U predict-on zmv zrecompile tetris edit-command-line

zle -N predict-on
zle -N predict-off
zle -N tetris
zle -N edit-command-line

bindkey -e
bindkey "^X^Z" predict-on # C-x C-z
bindkey "^Z" predict-off # C-z
bindkey '\ee' edit-command-line

zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e)"
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:match:*' original only
zstyle ':completion:predict:*' completer _oldlist _ignored _history _prefix

zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'

#zstyle :predict verbose yes
#zstyle :predict cursor key

zmodload zsh/attr zsh/cap zsh/clone zsh/regex
zmodload zsh/zftp
zmodload zsh/zpty
zmodload zsh/datetime
zmodload zsh/files
zmodload zsh/mathfunc
zmodload zsh/net/socket
zmodload zsh/net/tcp
zmodload zsh/system
zmodload zsh/zselect
zmodload -F zsh/stat b:zstat

typeset -U path cdpath manpath fpath

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
