ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"
CURRENT_OS=$(uname)
CURRENT_ARCH=$(uname -m)

plugins=(ssh-agent cpanm django extract git gitfast git-extras git-flow git-remote-branch github nyan svn perl pip python urltools cp history rsync color-man golang)
grep_path=$(which grep)

if [[ $CURRENT_OS = "Linux" ]]; then
	plugins+=(battery gnu-utils)
	if [[ -f /etc/arch-release ]]; then
		plugins+=(archlinux systemd)
		export OWL_AUR_HOME=/tmp/$(whoami)-aur
		export OWL_EDITOR=vim
		export OWL_IGNORE_OUTDATED=true
		export OWL_CLEAN_UP=true
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
elif [[ $CURRENT_OS = "FreeBSD" ]]; then
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
elif [[ $CURRENT_OS = "OpenBSD" ]]; then
	plugins+=()
	if [[ $TERM = "rxvt-unicode-256color" ]]; then
		export TERM=rxvt-256color
	fi
	export MANPATH="/usr/share/man:/usr/X11R6/man:/usr/local/man"
	export OPENBSD_CVSROOT="anoncvs@anoncvs.eu.openbsd.org:/cvs"
	DISABLE_LS_COLORS="true"
	export PKG_PATH="ftp://ftp.eu.openbsd.org/pub/OpenBSD/snapshots/packages/amd64/"
	export PATH="$PATH:/usr/local/go/bin:/usr/games"
	export GOPATH="/usr/local/go/"
	export LANG="en_US.UTF-8"
	export LC_CTYPE="en_US.UTF-8"
	export LC_ALL=en_US.UTF-8
	export LESSCHARSET="utf-8"
	export MAIL=$HOME/mail

	if [[ -f "/usr/local/bin/egdb" ]]; then
		alias gdb="/usr/local/bin/egdb"
	fi

	/usr/bin/skeyaaudit -i
elif [[ $CURRENT_OS = "Darwin" ]]; then
	plugins=(${plugins#ssh-agent}) # Don't use ssh-agent on Darwin/OSX
	export PATH="/Users/dxtr/perl5/perlbrew/bin:/Users/dxtr/perl5/perlbrew/perls/perl-5.16.1/bin:/usr/local/opt/ruby/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/Applications/Xcode.app/Contents/Developer/usr/bin"
	export LD_FLAGS="-L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/usr/lib"
	export LANG=en_US.UTF-8
	export JAVA_HOME="$(/usr/libexec/java_home)"
	#export EC2_PRIVATE_KEY="$(/bin/ls "$HOME"/.ec2/pk-*.pem | /usr/bin/head -1)"
	#export EC2_CERT="$(/bin/ls "$HOME"/.ec2/cert-*.pem | /usr/bin/head -1)"
	#export EC2_AMITOOL_HOME="/usr/local/Library/LinkedKegs/ec2-ami-tools/jars"
	compctl -f -x 'p[2]' -s "`/bin/ls -d1 /Applications/*/*.app /Applications/*.app | sed 's|^.*/\([^/]*\)\.app.*|\\1|;s/ /\\\\ /g'`" -- open
	alias run='open -a'
	export HOMEBREW_NO_EMOJI=y
	export HOMEBREW_CC="clang"

	if [[ -f "$HOME/.homebrew.sh" ]]; then
		. $HOME/.homebrew.sh
	fi
fi

if [[ $CURRENT_ARCH = "x86_64" ]]; then
	if command -v wine &>/dev/null; then
		export WINEARCH=win32
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

if [[ -d "$HOME/perl5" ]]; then
	if [[ -f "$HOME/perl5/perlbrew/etc/bashrc" ]]; then
		source $HOME/perl5/perlbrew/etc/bashrc
	else
		eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
	fi
fi

if [[ -d "$HOME/go" ]]; then
	export GOPATH=~/go:$GOPATH
	export PATH=$PATH:~/go/bin
fi

if [[ -d "$HOME/.gnupg" ]]; then
	if [[ -f "$HOME/.gnupg/gpg-agent.env" ]]; then
		. "$HOME/.gnupg/gpg-agent.env"
	else
		eval $(/usr/bin/env gpg-agent --quiet --daemon --write-env-file "$HOME/.gnupg/gpg-agent.env" 2> /dev/null)
		chmod 600 "$HOME/.gnupg/gpg-agent.env"
		export GPG_AGENT_INFO
	fi
	export GPG_TTY=$(tty)
fi

export GEM_HOME="$HOME/.gem"
export EDITOR=vim
export TZ="Europe/Stockholm"

if command -v nc &>/dev/null; then
	alias ssh-tor='ssh -o "ProxyCommand nc -X 5 -x 192.168.12.254:9050 %h %p"'
elif command -v torsocks &>/dev/null; then
	export TORSOCKS_CONF_FILE="$HOME/.torsocks.conf"
	alias ssh-tor='torsocks ssh'
fi

if command -v xterm &>/dev/null && command -v uxterm &>/dev/null; then
	alias xterm='uxterm'
fi

if command -v gpg2 &>/dev/null; then
	alias gpg='gpg2'
fi

typeset -U path cdpath manpath fpath
