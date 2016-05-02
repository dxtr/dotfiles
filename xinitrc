xresources=$HOME/.Xdefaults
xmodmap=$HOME/.Xmodmap

for x in /usr/local/share/fonts/*; do
	xset +fp $x
done

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
setxkbmap -layout us,se \
	  -variant altgr-intl,nodeadkeys \
	  -option \
	  -option "compose:rctl" \
	  -option "eurosign:e" \
	  -option "grp:alt_shift_toggle" \
	  -option "caps:none"
xsetroot -solid "#1b1e1c"
urxvtd -q -f -o
#export TERM=uxterm
export TERM=urxvtc
#pgrep -q xstatbar || xstatbar -t '%a %d %b %Y %H:%M' -f 6x12 &

xcompmgr &
exec xmonad
#exec ~/.cabal/bin/xmonad
#exec stumpwm
#exec ratpoison

