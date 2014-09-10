unset MAILCHECK
CURRENT_OS=$(uname)

# Set all environment variables
path=("/usr/local/bin" "/usr/local/sbin" "/usr/bin" "/usr/sbin" "/bin" "/sbin"
	"$HOME/.local/bin" "$HOME/.cabal/bin" "$HOME/go/bin" "$HOME/.gem/bin")

export GOPATH="$HOME/go"
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$HOME/.gem"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LESSCHARSET="utf-8"
export MAIL="$HOME/mail"
export TZ="Europe/Stockholm"
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
export EDITOR=emacs

if [[ $CURRENT_OS = "Darwin" ]]; then
	export LD_FLAGS="-L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk/usr/lib"
	path+=("/usr/local/CrossPack-AVR/bin"
		"/usr/local/opt/ruby/bin"
		"/opt/X11/bin"
		"/Applications/Xcode.app/Contents/Developer/usr/bin")
fi

running_gpg_agent=$(pgrep gpg-agent)
if [[ $? -eq 0 ]] && [[ -f ~/.keychain/$(hostname)-sh-gpg ]]; then
	if [[ $running_gpg_agent = "$(cat ~/.keychain/$(hostname)-sh-gpg | cut -d: -f 2)" ]]; then
		. ~/.keychain/$(hostname)-sh-gpg
	fi
fi

