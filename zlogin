[[ -S "/tmp/emacs$(id -u)/server" ]] || /usr/local/bin/emacs --daemon &> /dev/null &
#pgrep -qu $(id -u) -f 'emacs --daemon' || /usr/local/bin/emacs --daemon &> /dev/null
