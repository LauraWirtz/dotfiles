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
	Material.accent: Material.Green
	spacing: 0

	property var buttonsModel: [
		{ icon: "window-minimize-pip", size: 32, command: ()=>Niri.toggleWindowFloating() },
		{ icon: "view-fullscreen-symbolic", size: 32, command: ()=>Niri.fullscreenWindow() },
		{ icon: "kdenlive-slip", size: 32, command: ()=>Niri.centerColumn() },
		{ icon: "window-maximize", size: 32, command: ()=>Niri.switchPresetColumnWidth() },
		{ icon: "window-close", size: 32, command: ()=>Niri.closeWindow() },
	]

	Repeater {
		model: buttonsModel
		RoundButton {
			id: delegate
			icon.name: modelData.icon
			icon.color: "transparent"
			icon.width: modelData.size
			icon.height: modelData.size
			radius: 8
			flat: true

			onClicked: modelData.command()
		}
	}
}
