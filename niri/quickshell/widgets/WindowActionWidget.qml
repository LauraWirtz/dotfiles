// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

import QtQuick.Controls.Material

RowLayout {
	id: root
	Material.theme: Material.Dark
	Material.accent: Material.Pink
	spacing: 0

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
			flat: true

			onClicked: modelData.command()
		}
	}
}
