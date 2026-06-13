// ClockWidget.qml
import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

BreezeButton {
	icon.name: "input-keyboard-symbolic"
	icon.width: 24
	icon.height: 24
	square: false

	text: Niri.keyboardLayoutNames[Niri.currentKeyboardLayoutIndex] == "English (US)" ? "US" : Niri.keyboardLayoutNames[Niri.currentKeyboardLayoutIndex] == "German" ? "DE" : Niri.keyboardLayoutNames[Niri.currentKeyboardLayoutIndex]

	onClicked: Niri.cycleKeyboardLayout()
}
