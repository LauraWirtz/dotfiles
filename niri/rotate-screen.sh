outputs=$(niri msg --json outputs)

rotation=$(jq -r '.["eDP-1"].["logical"].["transform"]' <<< $outputs)


if [[ "$rotation" == "90" ]]; then
	niri msg output eDP-1 transform 270
else
	niri msg output eDP-1 transform normal
fi
