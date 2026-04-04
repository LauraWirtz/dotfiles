// ClockWidget.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../services"

import QtQuick.Controls.Material

RoundButton {
	Material.accent: Material.Pink

	id: root

	icon.width: 24
	icon.height: 24
	flat: true

	states: [
		State {
			name: "performance"
			when: TlpService.profile == "performance"
			PropertyChanges {root.icon.name: "battery-profile-performance"}
			PropertyChanges {root.Material.foreground: Material.Red}
			PropertyChanges {root.onClicked: TlpService.set([ "tlpctl", "balanced" ])}
		},
		State {
			name: "balanced"
			when: TlpService.profile == "balanced"
			PropertyChanges {root.icon.name: "battery-profile-powersave"}
			PropertyChanges {root.Material.foreground: Material.Green}
			PropertyChanges {root.onClicked: TlpService.set([ "tlpctl", "performance" ])}
		},
	]
}
