pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
  id: root
	property real percentage: 0
	property bool charging: false
	property string timeRemaining: "00:00"

	Timer {
		interval: 10000; running: true; repeat: true
		onTriggered: {
			interval = 10000 + 50 * root.percentage
			runner.running = root.percentage > 0
		}
	}

	Process {
		id: runner
		running: true
		command: [ "busctl", "get-property", "--system", "org.freedesktop.UPower", "/org/freedesktop/UPower/devices/DisplayDevice", "org.freedesktop.UPower.Device", "Percentage" ]
		stdout: SplitParser { onRead: data => root.percentage = data.match(/\d+/) }
	}

	function update(): void {
		percentage = (UPower.displayDevice.percentage * 100).toFixed(0);
		timeRemaining = formatTime(UPower.displayDevice.timeToFull+UPower.displayDevice.timeToEmpty)
	}

	function formatTime(seconds) {
		var h = Math.floor(seconds / 3600);
		var m = Math.floor((seconds % 3600) / 60);
		return `${ h.toString().padStart(2, '0') }:${ m.toString().padStart(2, '0') }`;
	}
}
