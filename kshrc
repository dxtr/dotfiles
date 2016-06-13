# -*- mode: sh -*-
# Stolen from openbsd /etc/ksh.kshrc
function no_path {
    eval _v="\$${2:-PATH}"
    case :$_v: in
	*:$1:*) return 1;;            # no we have it
    esac
    return 0
}
function add_path {
    [ -d ${1:-.} ] && no_path $* && eval ${2:-PATH}="\$${2:-PATH}:$1"
}
function pre_path {
    [ -d ${1:-.} ] && no_path $* && eval ${2:-PATH}="$1:\$${2:-PATH}"
}
function del_path {
    no_path $* || eval ${2:-PATH}=`eval echo :'$'${2:-PATH}: |
    sed -e "s;:$1:;:;g" -e "s;^:;;" -e "s;:\$;;"`
}
function add_ssh_key {
    keyfile="$1"
    pubkey="$keyfile.pub"
    
    if [ -f $keyfile -a -s $keyfile ]; then
	if [ -f $pubkey -a -s $pubkey ]; then
#	    key=$(cat $pubkey | tr -s '[:space:]' | cut -d' ' -f2)
	    ssh-add -L | grep -qs $(cat $pubkey | tr -s '[:space:]' | cut -d ' ' -f 2)
	    [ $? -eq 1 ] && ssh-add $keyfile
	else
	    ssh-add $keyfile
	fi
    fi
}
function ssh_agent_pid {
    uname=$(uname)
    myuid=$(id -u)
    if [ $uname = "Linux" ]; then
        pgrep -xu $myuid ssh-agent > /dev/null
    else
        pgrep -qxu $myuid
    fi
}
function ssh_auth_sock_exists {
    [ -e $SSH_AUTH_SOCK -a -S $SSH_AUTH_SOCK ]
}

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

add_path $HOME/.local/phpstorm/bin
add_path /usr/local/jdk-1.8.0/bin
pre_path ~/perl5/perlbrew/bin
pre_path ~/.racket/6.2.1/bin
pre_path $GOPATH/bin

export PATH PS1 EDITOR VISUAL PAGER HISTFILE HISTSIZE MAIL \
       GOPATH LESS

set -o noclobber
#set -o nounset
set -o markdirs

[ -d ~/.opam/opam-init ] && . ~/.opam/opam-init/init.sh

if [ ! -z $SSH_AUTH_SOCK ]; then
    if [ ! -e $SSH_AUTH_SOCK -o ! -S $SSH_AUTH_SOCK ]; then
        pkill ssh-agent
        unset SSH_AUTH_SOCK
        [ -f $TMPDIR/ssh-agent.sh ] && rm $TMPDIR/ssh-agent.sh
    fi
fi

if [ -z $SSH_AUTH_SOCK ]; then
    ssh_agent_pid || ssh-agent | grep -v ^echo > $TMPDIR/ssh-agent.sh
    # [ -z $(pgrep -xu $(id -u) ssh-agent) ] && ssh-agent | grep -v ^echo > $TMPDIR/ssh-agent.sh

    . $TMPDIR/ssh-agent.sh

    add_ssh_key $HOME/.ssh/id_ed25519
    add_ssh_key $HOME/.ssh/id_rsa
fi

export STEAM_RUNTIME=0
