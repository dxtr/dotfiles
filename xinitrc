wm=spectrwm
xkbmap=se

xrdb ~/.Xdefaults
xsetroot -solid #000000 &

if [ "$(uname)" == "Linux" ]; then
	if [ "$(hostname)" == "greger" ]; then
		xrandr --output DVI-I-2 --right-of DVI-I-1
		nvidia-settings -a InitialPixmapPlacement=2
		hsetroot ~/pictures/Stand_Back_by_TheScott87.png
		wm=startxfce4
	fi

	clipit -d &
elif [ "$(uname)" == "OpenBSD" ]; then
	export LC_CTYPE="en_US.UTF-8"
	autocutsel &
	xstatbar -T -w1366 -y754 &
fi

setxkbmap $xkbmap
xset s off
xmodmap -e 'remove Lock = Caps_Lock' -e 'keysym Caps_Lock = Escape'
urxvtd -q -f -o

exec $wm
