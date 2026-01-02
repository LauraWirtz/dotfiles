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

	Button {
		text: "Steam + Touchpad"
		onClicked: InputPlumber.setTargetDevices([ "touchpad", "deck-uhid"] )
	}
	Button {
		text: "Steam Input"
		onClicked: InputPlumber.setTargetDevices([ "deck-uhid"] )
	}
	Button {
		text: "Controller"
		onClicked: InputPlumber.setTargetDevices([ "xb360"] )
	}
}
