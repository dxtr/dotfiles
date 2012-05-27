if [ $(uname) = 'OpenBSD' ]
then
  export TERM=rxvt-256color
  export MANPATH=/usr/share/man
  DISABLE_LS_COLORS="true"
  plugins=(cpanm extract git git-flow github nya perl pip python)
else
  plugins=(archlinux battery cpanm debian django extract git git-flow github gnu-utils gpg-agent nyan osx perl pip python ssh-agent)
fi

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dxtr-repos"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
source $ZSH/oh-my-zsh.sh
#PATH="/usr/local/sbin:/usr/sbin:/sbin:$PATH:/home/dxtr/bin"
#zstyle ':completion:*' menu select=1
bindkey -e
export EDITOR=vim
alias tmux="tmux -2u"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
source ~/perl5/perlbrew/etc/bashrc
#eval $(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)

