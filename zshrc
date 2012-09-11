ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

if [[ $(uname) = "Linux" ]]; then
	if [[ -f /etc/arch-release ]]; then
		plugins=(archlinux battery cpanm django extract git git-flow github gnu-utils nyan perl pip python)
	elif [[ -f /etc/debian_version ]]; then
		plugins=(battery cpanm debian django extract git git-flow github gnu-utils nyan perl pip python)
	else
		plugins=(battery cpanm django extract git git-flow github gnu-utils nyan perl pip python)
	fi
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
	eval `dircolors ~/.dircolors`
elif [[ $(uname) = "FreeBSD" ]]; then
	plugins=(cpanm django extract git git-flow github gnu-utils nyan perl pip python)
	export LANG="en_US.UTF-8"
	export LC_ALL="en_US.UTF-8"
	DISABLE_LS_COLORS="true"
	if [[ -f "/usr/local/bin/gls" ]] && [[ -f "/usr/local/bin/gdircolors" ]] && [[ -f "/home/dxtr/.dircolors" ]]; then
		eval `/usr/local/bin/gdircolors ~/.dircolors`
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
PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH:/home/dxtr/bin"
#zstyle ':completion:*' menu select=1
bindkey -e
export EDITOR=vim
alias tmux="tmux -2u"
source /home/dxtr/perl5/perlbrew/etc/bashrc
export TZ="Europe/Stockholm"

autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on # C-x C-z
bindkey "^Z" predict-off # C-z
zstyle :predict verbose yes
zstyle :predict cursor key
zstyle ':completion:predict:*' completer _oldlist _complete _ignored _history _prefix
