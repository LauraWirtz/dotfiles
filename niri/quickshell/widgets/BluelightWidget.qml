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

		icon.name: "redshift-status-on"
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

		from: 2500
		to: 6500
		stepSize: 1
		live: false

		onMoved: {
			Niri.spawn([ "sunsetr", "set", "transition_mode=static" ])
			Niri.spawn([ "sunsetr", "set", "static_temp="+value ])
		}

		states: [
			State {
				name: "ACTIVE"
				when: (Niri.inOverview)
				PropertyChanges { statusGetter.running: true }
			}
		]

		Process {
			id: statusGetter
			running: false
			command: [ "sunsetr", "status", "--json", "--follow" ]
			stdout: SplitParser { onRead: rawData => {
				const event = JSON.parse(rawData)
				if(event.event_type == "state_applied") {
					autoButton.enabled = event.period == "static"
					slider.value = event.current_temp
				} else if(event.event_type == "period_changed") {
					autoButton.enabled = event.to_period == "static"
				}
			}}
		}
	}

	Button {
		id: autoButton
		icon.name: "clock"
		icon.width: 24
		icon.height: 24
		text: "Auto"
		// padding: 0

		onClicked: Niri.spawn([ "sunsetr", "set", "transition_mode=geo" ])
	}
}
