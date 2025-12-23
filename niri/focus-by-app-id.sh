windows=$(niri msg --json windows)

# quodlibet = io.github.quodlibet.QuodLibet

# focused=$(jq -r '.[] | select(.is_focused == true) | .app_id' <<< $windows)
focused=$(jq -r '. | max_by(.focus_timestamp.secs) | .app_id' <<< $windows)
wanted=$(jq -r 'first(.[] | select(.app_id == "'$1'") | .id)' <<< $windows)


if [[ "$focused" == "$1" ]]; then
	niri msg action focus-window-previous
else
	niri msg action focus-window --id $wanted
fi
