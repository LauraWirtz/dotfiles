// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

import QtQuick.Controls.Basic

RowLayout {
	id: root

	// Layout.fillWidth: true
	// Layout.preferredHeight: 24
	// Layout.preferredHeight: children[0].implicitHeight
	spacing: 12

	property var buttonsModel: [
		{ icon: "window-minimize-pip", command: ()=>Niri.toggleWindowFloating() },
		{ icon: "view-fullscreen", command: ()=>Niri.fullscreenWindow() },
		{ icon: "view-file-columns", command: ()=>Niri.centerColumn() },
		{ icon: "window-maximize", command: ()=>Niri.switchPresetColumnWidth() },
		{ icon: "window-close", command: ()=>Niri.closeWindow() },
	]

	Repeater {
		model: buttonsModel
		RoundButton {
			id: delegate
			icon.name: modelData.icon
			icon.color: "transparent"
			icon.width: 32
			icon.height: 32
			padding: 0
			flat: true

			onClicked: modelData.command()
		}
	}
}
