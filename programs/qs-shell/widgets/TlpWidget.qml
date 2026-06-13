// ClockWidget.qml
import QtQuick
import QtQuick.Controls
import "../items"
import "../services"

// import QtQuick.Controls.Material

BreezeButton {

	id: root

	icon.width: 24
	icon.height: 24

	states: [
		State {
			name: "performance"
			when: TlpService.profile == "performance"
			PropertyChanges {root.icon.name: "battery-profile-performance"}
			PropertyChanges {root.icon.color: "#F44336"}
			PropertyChanges {root.onClicked: TlpService.set([ "tlpctl", "balanced" ])}
		},
		State {
			name: "balanced"
			when: TlpService.profile == "balanced"
			PropertyChanges {root.icon.name: "battery-profile-powersave"}
			PropertyChanges {root.icon.color: "#4CAF50"}
			PropertyChanges {root.onClicked: TlpService.set([ "tlpctl", "performance" ])}
		},
	]
}
