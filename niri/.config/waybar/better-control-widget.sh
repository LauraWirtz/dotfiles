testfor=$1

file="/home/laura/.config/waybar/control-state" #the file where you keep your string name

active=$(cat "$file")        #the output of 'cat $file' is assigned to the $name variable

if pgrep -c "better-control"
then
	pkill better-control
	if [ $active == $testfor ]
	then
		echo "" > /home/laura/.config/waybar/control-state
	else
		nohup better-control -m -$testfor $>/dev/null &
		echo $testfor > /home/laura/.config/waybar/control-state
	fi
else
	nohup better-control -m -$testfor $>/dev/null &
	echo $testfor > /home/laura/.config/waybar/control-state
fi
