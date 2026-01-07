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
	Material.theme: Material.Dark
	Material.accent: Material.Pink
	Layout.fillWidth: true
	// spacing: 8

	Button {
		// Layout.leftMargin: -12

		icon.name: "audio-volume-high"
		icon.width: 24
		icon.height: 24
		display: AbstractButton.IconOnly
		background: {}
		padding: 0
		Layout.margins: -12
	}

	Slider {
		Layout.fillWidth: true
		Layout.preferredWidth: 300
		Layout.topMargin: -12
		Layout.bottomMargin: -12
		padding: 0

		id: slider

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
				onStreamFinished: { slider.value= this.text.match(/\d[.]\d\d/)[0] * 100 }
			}
		}
	}
}

