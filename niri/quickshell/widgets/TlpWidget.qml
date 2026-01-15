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
	spacing: 4

	id:root
	property string profile: ""

	Button {
		id: buttonPerf
		checked: root.profile == "performance"

		padding: 0

		icon.name: "battery-profile-performance"
		icon.width: 24
		icon.height: 24
		text: "Performance"

		onClicked: { if( root.profile != "performance") {
			statusSetter.command = [ "tlpctl", "performance" ]
			statusSetter.running = true
		} }
	}
	Button {
		id: buttonPower
		checked: root.profile == "balanced"
		padding: 0

		icon.name: "battery-profile-powersave"
		icon.width: 24
		icon.height: 24
		text: "Powersave"

		onClicked: { if( root.profile != "balanced") {
			statusSetter.command = [ "tlpctl", "balanced" ]
			statusSetter.running = true
		} }
	}
	states: [
		State {
			name: "ACTIVE"
			when: (Niri.inOverview)
			StateChangeScript { script: {statusGetter.running = true} }
		},
	]

	Timer {
		interval: 3000; running: Niri.inOverview; repeat: true
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
