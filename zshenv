CURRENT_OS=$(uname)

path=("/bin" "/sbin" "/usr/bin" "/usr/sbin" "/usr/local/bin" "/usr/local/sbin"
	"$HOME/.local/bin" "$HOME/.cabal/bin" "$HOME/go/bin" "$HOME/.gem/bin")


# Envionment variables
export GOPATH="$HOME/go"
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$HOME/.gem"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LESSCHARSET="utf-8"
export MAIL="$HOME/mail"

if [[ $CURRENT_OS = "Linux" ]]; then
elif [[ $CURRENT_OS = "FreeBSD" ]]; then
elif [[ $CURRENT_OS = "OpenBSD" ]]; then
elif [[ $CURRENT_OS = "Darwin" ]]; then
	export LD_FLAGS="-L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/usr/lib"
	path+=("/usr/local/CrossPack-AVR/bin"
		"/usr/local/opt/ruby/bin"
		"/opt/X11/bin"
		"/Applications/Xcode.app/Contents/Developer/usr/bin"
	)
fi
