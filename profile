PATH=$HOME/.local/bin:$HOME/.cabal/bin:$HOME/bin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin:/usr/games:.
ENV=$HOME/.kshrc
PS1='\u@\H:\w \$'
TMPDIR="/tmp/$LOGNAME"

test -d "$TMPDIR" || mkdir -p -m 700 "$TMPDIR"

export PATH HOME TERM ENV PS1 TMPDIR

alias gpg='gpg2'

if [ "$(uname)" = "Linux" ]; then
    export LC_TIME="en_DK.UTF-8"
fi
