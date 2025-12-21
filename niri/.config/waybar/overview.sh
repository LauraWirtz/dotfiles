overview=$(niri msg --json overview-state)
if [[ $overview == *"true"* ]]; then
	pkill -SIGUSR1 waybar
	echo "/home/laura/.config/waybar/icons/actions/24/go-down.svg"
else
	pkill -SIGUSR2 waybar
	echo "/home/laura/.config/waybar/icons/actions/24/go-up.svg"
fi
