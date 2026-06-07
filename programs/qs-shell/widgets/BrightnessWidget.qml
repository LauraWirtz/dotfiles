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
	Material.accent: Material.Green
	Layout.fillWidth: true
	// spacing: 8

	Button {
		// Layout.leftMargin: -12

		icon.name: "brightness-high"
		icon.width: 24
		icon.height: 24
		display: AbstractButton.IconOnly
		background: {}
		padding: 0
		Layout.margins: -12
	}

	Slider {
		Layout.fillWidth: true
		Layout.alignment: Qt.AlignVCenter
		Layout.preferredWidth: 300
		Layout.topMargin: -12
		Layout.bottomMargin: -12
		padding: 0

		id: slider

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
				onStreamFinished: { slider.value= this.text.match(/\d+%/)[0].match(/\d+/) }
			}
		}
	}
}
