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
		source: "/home/laura/.local/share/icons/Breeze-dark/actions/24/brightness-high.svg"
		icon_width: 24
		icon_height: 24

		topPadding: 8
		bottomPadding: 8
		leftPadding: 16
		rightPadding: -8
	}

	Slider {
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: slider

		from: 0
		to: 100

		rightPadding: 16

		implicitWidth: 250
		implicitHeight: 24

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
