// ClockWidget.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../items"
import "../services"

Item {
	implicitWidth: children[0].implicitWidth + 32
	implicitHeight: 40
	Text {
		x: 16
		anchors.verticalCenter: parent.verticalCenter
		color: "white"
		font.pixelSize: 16
		text: Niri.keyboardLayoutNames[Niri.currentKeyboardLayoutIndex] == "English (US)" ? "US" : Niri.keyboardLayoutNames[Niri.currentKeyboardLayoutIndex] == "German" ? "DE" : Niri.keyboardLayoutNames[Niri.currentKeyboardLayoutIndex]
	}
	TapHandler {
		id: handler
		gesturePolicy: TapHandler.ReleaseWithinBounds
		onTapped: Niri.cycleKeyboardLayout()
	}
}
