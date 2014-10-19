# -*- mode: sh -*-

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_AUTO_UPDATE="true"
CURRENT_OS=$(uname)
CURRENT_ARCH=$(uname -m)
EXTRA_MANPATHS=("$HOME/.local/share/man")

plugins=(cpanm django extract git gitignore gitfast git-extras git-flow git-remote-branch github nyan svn perl python pip urltools cp history rsync golang cabal)
grep_path=$(which grep)

# System specific stuff
if [[ $CURRENT_OS = "Linux" ]]; then
	plugins+=(battery gnu-utils colorize common-aliases virtualenv virtualenvwrapper)
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
	elif [[ -f /usr/bin/crux ]]; then
		pkg_db="/var/lib/pkg/db"
		hash -d ports="/usr/ports"
		grep -qsE ^fakeroot $pkg_db && alias pkgmk='fakeroot pkgmk'
	fi

	test -f "$HOME/.dircolors" && eval `dircolors ~/.dircolors`

	alias grep="$grep_path --color=auto"
	alias grepn="$grep_path -n --color=auto"
	alias rstbl="xbacklight -set 75"

	ulimit -c unlimited

	zmodload zsh/attr
elif [[ $CURRENT_OS = "FreeBSD" ]]; then
	plugins+=(gnu-utils)
	DISABLE_LS_COLORS="true"
	if [[ -f "/usr/local/bin/gls" ]] && [[ -f "/usr/local/bin/gdircolors" ]]; then
		if [[ -f "$HOME/.dircolors" ]]; then
			eval `/usr/local/bin/gdircolors ~/.dircolors`
		fi
		alias ls="/usr/local/bin/gls --color=auto"
	fi
elif [[ $CURRENT_OS = "OpenBSD" ]]; then
	plugins=(${plugins#colorize})
	plugins+=(virtualenv)
	if [[ $TERM = "rxvt-unicode-256color" ]]; then
		export TERM=rxvt-256color
	fi
	export MANPATH="/usr/share/man:/usr/X11R6/man:/usr/local/man"
	export OPENBSD_CVSROOT="anoncvs@anoncvs.eu.openbsd.org:/cvs"
	DISABLE_LS_COLORS="true"
	export PKG_PATH="ftp://ftp.eu.openbsd.org/pub/OpenBSD/snapshots/packages/amd64/"
	path+=(/usr/games)

	if [[ -f "/usr/local/bin/egdb" ]]; then
		alias gdb="/usr/local/bin/egdb"
	fi

	if [[ -d "/etc/skey" ]] && [[ -f "/etc/skey/$(whoami)" ]]; then
		/usr/bin/skeyaudit -i
	fi
	
	source ~/.zsh/openbsd-functions.sh
elif [[ $CURRENT_OS = "Darwin" ]]; then
	plugins=(${plugins#ssh-agent}) # Don't use ssh-agent on Darwin/OSX
	plugins+=(brew brew-cask osx)
	export JAVA_HOME="$(/usr/libexec/java_home)"
	compctl -f -x 'p[2]' -s "`/bin/ls -d1 /Applications/*/*.app /Applications/*.app | sed 's|^.*/\([^/]*\)\.app.*|\\1|;s/ /\\\\ /g'`" -- open
	alias run='open -a'
	alias which='/usr/bin/which'
	export HOMEBREW_NO_EMOJI=y
	export HOMEBREW_CC="clang"
	export HOMEBREW_GITHUB_API_TOKEN="6598dee8d95367508b6794a3c24d2452b39d8266"
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
alias emacs="emacsclient -c"
alias -s tex="vim"
alias -s txt="less"
alias -s c="vim"
alias -s cpp="vim"
alias -s html="w3m"
alias -s png="xv"
alias -s gif="xv"
alias -s jpg="xv"
alias -s pdf="xpdf"

if command -v xterm &>/dev/null && command -v uxterm &>/dev/null; then
	alias -s xterm='uxterm'
fi
if command -v gpg2 &>/dev/null; then
	alias -s gpg='gpg2'
fi


if [[ -d "$HOME/perl5/perlbrew" ]]; then
	if [[ -f "$HOME/perl5/perlbrew/etc/bashrc" ]]; then
		source $HOME/perl5/perlbrew/etc/bashrc
	else
		eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)
	fi
fi

for p in $EXTRA_MANPATHS; do
	test -d $p && manpath+=$p
done

if [[ $CURRENT_OS != "Darwin" || ! -d "/usr/local/MacGPG2" ]]; then
	if command -v keychain &>/dev/null; then
		if [[ $CURRENT_OS != "Darwin" ]]; then
			eval $(keychain --ignore-missing --quick --quiet --nocolor --nogui --eval id_rsa 46726B9A)
		else
			eval $(keychain --agents gpg --ignore-missing --quick --quiet --nocolor --nogui --eval 46726B9A)
		fi
	elif [[ -d "$HOME/.gnupg" ]]; then
		if [[ -f "$HOME/.gnupg/gpg-agent.env" ]]; then
			. "$HOME/.gnupg/gpg-agent.env"
		else
			if [[ $CURRENT_OS != "Darwin" ]]; then
				eval $(/usr/bin/env gpg-agent --quiet --daemon --enable-ssh-support --write-env-file "$HOME/.gnupg/gpg-agent.env" 2> /dev/null)
			else
				eval $(/usr/bin/env gpg-agent --quiet --daemon --write-env-file "$HOME/.gnupg/gpg-agent.env" 2> /dev/null)
			fi
			chmod 600 "$HOME/.gnupg/gpg-agent.env"
			export GPG_AGENT_INFO
		fi
	fi
fi

export GPG_TTY=$(tty)

if command -v virtualenv &>/dev/null; then
   if command -v virtualenvwrapper.sh &>/dev/null; then
   	  export WORKON_HOME=$HOME/.venv
	  source $(command -v virtualenvwrapper.sh)
   fi
	syspip(){
		PIP_REQUIRE_VIRTUALENV="" pip "$@"
	}
	syspip3() {
		PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
	}
fi



typeset -U path cdpath manpath fpath

# Custom functions
print_colors() {
	perl -e 'print map sprintf("\x1b[38;5;%um%4u", $_, $_), 0 .. 255; print "\n"'
}

unset MANPATH
