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
	spacing: 0

	id:root
	property string profile: ""

	RoundButton {
		id: button
		// padding: 0

		icon.name: root.profile == "performance" ? "battery-profile-performance" : "battery-profile-powersave"
		icon.width: 32
		icon.height: 32
		Material.foreground: root.profile == "performance" ? Material.Red : Material.Green
		// radius: 8
		flat: true

		onClicked: {
			if( root.profile == "performance") {
				statusSetter.command = [ "tlpctl", "balanced" ]
				statusSetter.running = true
			} else if( root.profile == "balanced") {
				statusSetter.command = [ "tlpctl", "performance" ]
				statusSetter.running = true
			}
		}
	}
	states: [
		State {
			name: "ACTIVE"
			when: (Niri.inOverview)
			StateChangeScript { script: {statusGetter.running = true} }
		},
	]

	Timer {
		interval: 1000; running: Niri.inOverview; repeat: true
		onTriggered: { statusGetter.running = true }
	}
	Process {
		id: statusGetter
		running: false
		command: [ "tlpctl", "get", ]
		stdout: SplitParser { onRead: data => root.profile = data }
	}
	Process {
		id: statusSetter
		running: false
	}
}
