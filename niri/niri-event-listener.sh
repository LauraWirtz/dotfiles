until pidof waybar
do
	sleep 1
done

while true
do
	niri msg --json event-stream | grep -q "OverviewOpenedOrClosed"
 	pkill -SIGRTMIN+2 waybar
	overview=$(niri msg --json overview-state)
	if [[ $overview == *"true"* ]]; then
		pkill -SIGUSR1 waybar
	else
		pkill -SIGUSR2 waybar
	fi
done
