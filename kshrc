. /etc/ksh.kshrc

PS1='\u@\h:\w \$ '
EDITOR='emacs'
VISUAL='emacs'
PAGER='less'
HISTFILE=~/.history
HISTSIZE=5000
MAIL=1
LANG=en_US.UTF-8
GOPATH=~/.local/go
LESS='-F -g -i -M -R -S -w -X -x-4'

add_path /usr/local/jdk-1.8.0/bin
pre_path ~/perl5/perlbrew/bin
pre_path ~/.racket/6.2.1/bin
pre_path $GOPATH/bin

export PATH PS1 EDITOR VISUAL PAGER HISTFILE HISTSIZE MAIL \
       GOPATH LESS

set -o noclobber
#set -o nounset
set -o markdirs

test -d ~/.opam/opam-init && . ~/.opam/opam-init/init.sh

if [[ -z $SSH_AUTH_SOCK ]]; then
    if ! pgrep -qxu $(id -u) ssh-agent; then
	ssh-agent | grep -v ^echo > $TMPDIR/ssh-agent.sh
    fi

    . $TMPDIR/ssh-agent.sh

    test -f ~/.ssh/id_ed25519.pub && ssh-add ~/.ssh/id_ed25519
    test -f ~/.ssh/id_rsa.pub && ssh-add ~/.ssh/id_rsa
fi

