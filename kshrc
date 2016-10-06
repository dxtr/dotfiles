# -*- mode: sh -*-
# Stolen from openbsd /etc/ksh.kshrc
function no_path {
    eval _v="\$${2:-PATH}"
    case :$_v: in
	*:$1:*) return 1;;            # no we have it
    esac
    return 0
}
function no_perllib_path {
    eval _v="\$${2:-PERL5LIB}"
    case :$_v: in
	*:$1:*) return 1;;            # no we have it
    esac
    return 0
}

# Add different paths
function add_path {
    if [ -n $(eval echo \$${2:-PATH}) ]; then
        [ -d ${1:-.} ] && no_path $* && eval ${2:-PATH}="\$${2:-PATH}:$1"
    else
        eval ${2:-PATH}="$1"
    fi
}
function pre_path {
    if [ -n $(eval echo \$${2:-PATH}) ]; then
        [ -d ${1:-.} ] && no_path $* && eval ${2:-PATH}="$1:\$${2:-PATH}"
    else
        no_path $* && eval ${2:-PATH}="$1"
    fi
}

# Remove paths
function del_path {
    no_path $* || eval ${2:-PATH}=`eval echo :'$'${2:-PATH}: |
    sed -e "s;:$1:;:;g" -e "s;^:;;" -e "s;:\$;;"`
}

# Other functions
function add_ssh_key {
    keyfile="${1:-id_rsa}"
    pubkey="$keyfile.pub"
    
    if [ -f $keyfile -a -s $keyfile ]; then
	if [ -f $pubkey -a -s $pubkey ]; then
#	    key=$(cat $pubkey | tr -s '[:space:]' | cut -d' ' -f2)
	    ssh-add -L | grep -qs $(cat $pubkey | tr -s '[:space:]' | cut -d ' ' -f 2) || ssh-add $keyfile
	    #[ $? -eq 1 ] && ssh-add $keyfile
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
        pgrep -qxu $myuid ssh-agent
    fi
}
function ssh_auth_sock_exists {
    [ -e $SSH_AUTH_SOCK -a -S $SSH_AUTH_SOCK ]
}

function twitch {
    livestreamer "https://twitch.tv/$1" best
}

function twitch-past {
    livestreamer "https://twitch.tv/$1/v/$2" best
}

function opam-switch-eval {
    opam switch "$@" --no-warning
    eval $(opam config env)
}
function current_ocaml_version {
   grep -Eo '[[:digit:]]{1,2}\.[[:digit:]]{1,2}\.[[:digit:]]{1,2}' $HOME/.opam/config
}


alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"

# Variables
PS1='\u@\h:\w \$ '
EDITOR='emacsclient -c'
VISUAL='emacsclient -c'
PAGER='less'
HISTFILE=~/.history
HISTSIZE=5000
MAIL=1
LANG=en_US.UTF-8
GOPATH=~/.local/go
LESS='-F -g -i -M -R -S -w -X -x-4'
OCAML_VERSION=$(current_ocaml_version)
ALTERNATE_EDITOR=emacs
MAILDIR="$HOME/mail"
PERL5LIB="$HOME/perl5/lib/perl5"
PERL_LOCAL_LIB_ROOT="$HOME/dxtr/perl5"
PERL_MB_OPT="--install_base \"$HOME/perl5\""
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
STEAM_RUNTIME=0
MANPATH="$HOME/.local/man"

# Add stuff to PATH
add_path $HOME/.local/phpstorm/bin PATH
add_path /usr/local/jdk-1.8.0/bin PATH
add_path /usr/bin/vendor_perl PATH
#pre_path $(ruby -rubygems -e "puts Gem.user_dir")/bin PATH
pre_path ~/perl5/bin PATH
pre_path ~/.racket/6.2.1/bin PATH
pre_path "$HOME/.opam/$OCAML_VERSION/bin"

if [ -d $GOPATH ]; then
    pre_path "$GOPATH/bin" PATH
fi

# Add stuff to MANPATH
add_path "$HOME/.local/man" MANPATH
add_path "$HOME/.opam/$OCAML_VERSION/man" MANPATH
add_path "/usr/share/man" MANPATH

# Add stuff to PERL5LIB
add_path "$HOME/.opam/$OCAML_VERSION/lib/perl5" PERL5LIB

# Add all OCaml paths
if [ -n "$OCAML_VERSION" ]; then
    export OCAML_TOPLEVEL_PATH="$HOME/.opam/$OCAML_VERSION/lib/toplevel"
    export CAML_LD_LIBRARY_PATH="/home/dxtr/.opam/$OCAML_VERSION/lib/stublibs:/usr/lib/ocaml/stublibs"
    export OCAML_VERSION
fi

export PATH PS1 EDITOR VISUAL PAGER HISTFILE HISTSIZE MAIL \
       GOPATH LESS ALTERNATE_EDITOR MAILDIR PERL5LIB \
       PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT MANPATH \
       STEAM_RUNTIME LANG

set -o noclobber
#set -o nounset
set -o markdirs

if [ -n $SSH_AUTH_SOCK ]; then
    if [ ! -S $SSH_AUTH_SOCK ]; then
        pkill ssh-agent
        unset SSH_AUTH_SOCK
        [ -f $TMPDIR/ssh-agent.sh ] && rm $TMPDIR/ssh-agent.sh
    fi
fi

if [ -z $SSH_AUTH_SOCK ]; then
    ssh_agent_pid || ssh-agent | grep -v ^echo > $TMPDIR/ssh-agent.sh
    # [ -z $(pgrep -xu $(id -u) ssh-agent) ] && ssh-agent | grep -v ^echo > $TMPDIR/ssh-agent.sh

    if [ -f $TMPDIR/ssh-agent.sh ]; then
        . $TMPDIR/ssh-agent.sh

        add_ssh_key $HOME/.ssh/id_ed25519
        add_ssh_key $HOME/.ssh/id_rsa
    fi
fi

