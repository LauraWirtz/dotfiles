// ClockWidget.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

import QtQuick.Controls.Material

RowLayout {
	Material.theme: Material.Dark
	Material.accent: Material.Pink

	spacing: 16

	property var buttonsModel: [
		{ name: "Steam Only", icon: "input-touchpad-off", targets: [ "deck-uhid" ] },
		{ name: "Steam Input", icon: "tablet", targets: [ "keyboard", "touchpad", "deck-uhid" ] },
		{ name: "Controller", icon: "input-gamepad-symbolic", targets: [ "keyboard", "touchpad", "xb360" ] }
	]

	Repeater {
		model: buttonsModel
		Button {
			icon.name: modelData.icon
			icon.width: 24
			icon.height: 24
			id: delegate
			text: modelData.name
			onClicked: InputPlumber.setTargetDevices(modelData.targets)

			Connections {
				target: InputPlumber
				function onUpdated() {
					delegate.enabled = !checkArrayEquality(InputPlumber.targetStrings, modelData.targets)
				}
			}
		}
	}


	function checkArrayEquality(a, b): bool {
		return a.every(item => b.includes(item)) && b.every(item => a.includes(item))
	}
}
