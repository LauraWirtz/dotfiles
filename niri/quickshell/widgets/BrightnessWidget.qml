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
	spacing: 0

	Button {
		icon.name: "brightness-high"
		icon.width: 24
		icon.height: 24
		display: AbstractButton.IconOnly
		background: {}
		padding: 0
	}

	Slider {
		Layout.fillWidth: true
		Layout.preferredWidth: 300
		Layout.preferredHeight: 40

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
