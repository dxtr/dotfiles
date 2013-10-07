if [[ -d "$HOME/bin" ]]; then
	PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/x-tools/arm-unknown-linux-gnueabihf/bin" ]]; then
	PATH="$HOME/x-tools/arm-unknown-linux-gnueabihf/bin:$PATH"
fi

if [[ -d "/opt/android-sdk/tools" ]]; then
	PATH="/opt/android-sdk/tools:$PATH"
fi

if [[ -d "/opt/android-sdk/platform-tools" ]]; then
	PATH="/opt/android-sdk/platform-tools:$PATH"
fi
