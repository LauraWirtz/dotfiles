// Time.qml
pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.UPower

Singleton {
  id: root
  // an expression can be broken across multiple lines using {}
	property real percentage
	property bool charging
	property string timeRemaining

	Component.onCompleted: update()

	Connections {
		target: UPower.displayDevice

		function onPercentageChanged(): void { update() }
		function onTimeToEmptyChanged(): void { update() }
		function onTimeToFullChanged(): void { update() }

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
