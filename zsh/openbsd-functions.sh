function battery() {
	if [[ $1 = "left" ]]; then
		printf "%.1f%%" $(($(sysctl -n hw.sensors.acpibat0.watthour3 | cut -d ' ' -f 1)/$(sysctl -n hw.sensors.acpibat0.watthour0 | cut -d ' ' -f 1)*100))
	elif [[ $1 = "health" ]]; then
		printf "%.1f%%" $(($(sysctl -n hw.sensors.acpibat0.watthour0 | cut -d ' ' -f 1)/$(sysctl -n hw.sensors.acpibat0.watthour4 | cut -d ' ' -f 1)*100))
	else
		echo "Unknown argument '$*'"
	fi
}
