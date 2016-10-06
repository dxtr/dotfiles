# -*- mode: sh -*-
PATH=$HOME/.local/bin:$HOME/.cabal/bin:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
ENV=$HOME/.kshrc
PS1='\u@\H:\w \$'
TMPDIR="/tmp/$LOGNAME"
DEFLOCALE="en_DK.UTF-8"

[ -d "$TMPDIR" ] || mkdir -p -m 700 "$TMPDIR"

export PATH HOME TERM ENV PS1 TMPDIR

alias gpg='gpg2'

if [ "$(uname)" = "Linux" ]; then
    export LC_CTYPE=$DEFLOCALE
    export LC_TIME=$DEFLOCALE
    export LC_COLLATE=$DEFLOCALE
    export LC_MONETARY=$DEFLOCALE
    export LC_MESSAGES=$DEFLOCALE
    export LC_PAPERS=$DEFLOCALE
    export LC_NAME=$DEFLOCALE
    export LC_ADDRESS=$DEFLOCALE
    export LC_TELEPHONE=$DEFLOCALE
    export LC_MEASUREMENT=$DEFLOCALE
    export LC_IDENTIFICATION=$DEFLOCALE

    export LANG="en_US.UTF-8"
    export LC_NUMERIC="en_US.UTF-8"
fi

# OPAM configuration
. /home/dxtr/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
