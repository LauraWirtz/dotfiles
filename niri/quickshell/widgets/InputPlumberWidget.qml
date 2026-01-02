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
		{ name: "Steam + Touchpad", targets: [ "touchpad", "deck-uhid" ] },
		{ name: "Steam Input", targets: [ "deck-uhid" ] },
		{ name: "Controller", targets: [ "xb360" ] }
	]

	Repeater {
		model: buttonsModel
		Button {
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
