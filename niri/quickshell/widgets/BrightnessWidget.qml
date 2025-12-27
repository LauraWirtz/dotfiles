// ClockWidget.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../services"

Slider {
	id: root

	from: 0
	to: 100

	onMoved: Niri.spawn([ "brightnessctl", "s", value+"%" ])

	states: [
		State {
			name: "ACTIVE"
			when: (Niri.inOverview)
			PropertyChanges { brightness_getter.running: true }
		}
	]

	Process {
		id: brightness_getter
		running: false
		command: [ "brightnessctl", "-m", "i" ]
		stdout: StdioCollector {
			onStreamFinished: { root.value= this.text.match(/\d+%/)[0].match(/\d+/) }
		}
	}
}
