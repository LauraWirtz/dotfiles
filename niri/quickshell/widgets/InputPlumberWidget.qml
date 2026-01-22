// ClockWidget.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

import QtQuick.Controls.Material

RowLayout {
	Material.theme: Material.Dark
	Material.accent: Material.Pink
	spacing: 4

	property var buttonsModel: [
		// { name: "Mouse + Keeb", icon: "input-keyboard-virtual", targets: [ "touchpad", "mouse", "keyboard"], profile: "mkb" },
		{ name: "Steam Input", icon: "steam_tray_mono", targets: [ "keyboard", "touchpad", "deck-uhid" ], profile: "default" },
		{ name: "Controller", icon: "input-gamepad-symbolic", targets: [ "keyboard", "touchpad", "xb360" ], profile: "default" }
	]

	Repeater {
		model: buttonsModel
		Button {
			id: delegate
			Layout.fillWidth: true

			icon.name: modelData.icon
			icon.width: 24
			icon.height: 24
			icon.color: "transparent"
			text: modelData.name
			onClicked: {
				InputPlumber.setTargetDevices(modelData.targets)
				InputPlumber.setProfile(modelData.profile)
			}

			Connections {
				target: InputPlumber
				function onUpdated() {
					delegate.checked = checkArrayEquality(InputPlumber.targetStrings, modelData.targets) && modelData.profile == InputPlumber.profile
				}
			}
		}
	}


	function checkArrayEquality(a, b): bool {
		return a.every(item => b.includes(item)) && b.every(item => a.includes(item))
	}
}
