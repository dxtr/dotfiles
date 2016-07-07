# -*- mode: sh -*-

xresources=$HOME/.Xdefaults
xmodmap=$HOME/.Xmodmap

if [ -d /usr/local/share/fonts ]; then
    for x in /usr/local/share/fonts/*; do
        xset +fp $x
    done
elif [ -d /usr/share/fonts ]; then
    for x in /usr/share/fonts/*; do
        xset +fp $x
    done
fi

if [ -f $xresources ]; then
    xrdb -merge $xresources
fi

if [ -f $xmodmap ]; then
    xmodmap $xmodmap
fi

if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
    eval `/usr/local/bin/dbus-launch --sh-syntax --exit-with-session`
fi

if [ -x /usr/local/bin/gnome-keyring-daemon -a -z "${GNOME_KEYRING_CONTROL}" ]; then
    for x in $(ps x|awk '$5 ~ /gnome-keyring-daemon/ {print $1}'); do
	kill $x
    done
    GKD=`/usr/local/bin/gnome-keyring-daemon -d --components=secrets,pkcs11`
    if [ ! -z $GKD ]; then
	export $GKD
    fi
fi

xset fp rehash
xset s blank
xset -b

kbd_layout="us"
kbd_variant="altgr-intl"

if [ "$(hostname -s)" = "greger" ]; then
    kbd_layout="us,se"
    kbd_variant="altgr-intl,nodeadkeys"
fi

setxkbmap -layout $kbd_layout \
	  -variant $kbd_variant \
	  -option \
	  -option "compose:rctl" \
	  -option "eurosign:e" \
	  -option "grp:alt_shift_toggle" \
	  -option "caps:none" \
	  -option "terminate:ctrl_alt_bksp"
xsetroot -solid "#1b1e1c"
urxvtd -q -f -o
export TERM=urxvtc
#pgrep -q xstatbar || xstatbar -t '%a %d %b %Y %H:%M' -f 6x12 &

if [ "$(hostname -s)" = "greger" ]; then
    nitrogen --restore
fi
xcompmgr &

exec xmonad
#exec ~/.cabal/bin/xmonad
#exec stumpwm
#exec ratpoison

