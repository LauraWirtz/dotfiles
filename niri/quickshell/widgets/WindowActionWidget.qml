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
		{ icon: "window-minimize-pip", size: 24, command: ()=>Niri.toggleWindowFloating() },
		{ icon: "panel-fit-width", size: 24, command: ()=>Niri.centerColumn() },
		{ icon: "window-minimize", size: 32, command: ()=>Niri.switchPresetColumnWidth() },
		{ icon: "window-maximize", size: 32, command: ()=>Niri.fullscreenWindow() },
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
			flat: true

			onClicked: modelData.command()
		}
	}
}
