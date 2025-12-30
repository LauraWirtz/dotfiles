// ClockWidget.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"


import QtQuick.Controls.Material

RowLayout {
	IconButton {
		source: "/home/laura/.local/share/icons/Breeze-dark/status/24/audio-volume-high.svg"
		icon_width: 24
		icon_height: 24

		topPadding: 8
		bottomPadding: 8
		leftPadding: 16
		rightPadding: 0
	}

	Slider {
		Layout.fillWidth: true
		Layout.preferredWidth: 200
		Layout.preferredHeight: 40
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: slider

		from: 0
		to: 100

		rightPadding: 16

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
				onStreamFinished: { slider.value= this.text.match(/\d[.]\d\d/)[0] * 100 }
			}
		}
	}
}

