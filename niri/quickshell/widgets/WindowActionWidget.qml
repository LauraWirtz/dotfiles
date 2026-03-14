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
		{ icon: "window-minimize-pip", size: 24, color: Material.Teal, command: ()=>Niri.toggleWindowFloating() },
		{ icon: "view-fullscreen-symbolic", size: 24, color: Material.Green, command: ()=>Niri.fullscreenWindow() },
		{ icon: "kdenlive-slip", size: 24, color: Material.Yellow, command: ()=>Niri.centerColumn() },
		{ icon: "window-maximize", size: 24, color: Material.Orange, command: ()=>Niri.switchPresetColumnWidth() },
		{ icon: "window-close", size: 24, color: Material.Red, command: ()=>Niri.closeWindow() },
	]

	Repeater {
		model: buttonsModel
		RoundButton {
			Layout.margins: -0

			id: delegate

			icon.name: modelData.icon
			// icon.color: "transparent"
			icon.width: modelData.size
			icon.height: modelData.size
			Material.foreground: Material.color(modelData.color, Material.Shade200)
			// Material.roundedScale: Material.FullScale
			flat: true

			onClicked: modelData.command()
		}
	}
}
