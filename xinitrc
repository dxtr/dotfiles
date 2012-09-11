setxkbmap se
xset s off
xmodmap -e 'remove Lock = Caps_Lock' -e 'keysym Caps_Lock = Escape'
urxvtd -q -f -o
clipit -d &
#hsetroot -center /home/dxtr/pictures/Stand_Back_by_TheScott87.png
/usr/bin/hsetroot -solid #002b36
xrdb ~/.Xdefaults &

xrandr --output DVI-I-2 --right-of DVI-I-1
nvidia-settings -a InitialPixmapPlacement=2

#exec ratpoison
#exec sscrotwm
exec pekwm
