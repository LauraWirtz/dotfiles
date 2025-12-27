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

	onMoved: Niri.spawn([ "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", value+"%" ])

	states: [
		State {
			name: "ACTIVE"
			when: (Niri.inOverview)
			PropertyChanges { volume_getter.running: true }
		}
	]

	Process {
		id: volume_getter
		running: false
		command: [ "wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@" ]
		stdout: StdioCollector {
			onStreamFinished: { root.value= this.text.match(/\d[.]\d\d/)[0] * 100 }
		}
	}
}
