setxkbmap se
xmodmap -e 'remove Lock = Caps_Lock' -e 'keysym Caps_Lock = Escape'
synclient TapAndDragGesture=0
synclient VertTwoFingerScroll=0
synclient TapButton1=0
synclient TapButton2=0
synclient TapButton3=0
synclient PalmDetect=1
#synclient Touchpadoff=1
#unclutter -idle 2 -noevents -root &
#syndaemon -d -i 1
urxvtd -q -f -o
hsetroot -center /home/dxtr/pictures/Stand_Back_by_TheScott87.png
xrdb ~/.Xdefaults &
exec pekwm
