// Bar.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

RowLayout {
	id: root
	Material.theme: Material.Dark
	Material.accent: Material.Green
	spacing: 0

	property var windowModelData

	property var buttonsModel: [
		// { icon: "window-minimize-pip", size: 24, color: Material.Teal, command: ()=>Niri.toggleWindowFloating() },
		{ icon: "view-fullscreen-symbolic", size: 24, color: Material.Green, command: ()=>Niri.fullscreenWindow() },
		{ icon: "kdenlive-slip", size: 24, color: Material.Yellow, command: ()=>Niri.centerWindow() },
		{ icon: "window-maximize", size: 24, color: Material.Orange, command: ()=>Niri.switchPresetWindowWidth() },
		{ icon: "window-close", size: 24, color: Material.Red, command: ()=>Niri.closeWindow() },
	]

	Repeater {
		model: buttonsModel
		BreezeButton {
			id: delegate

			square: true

			icon.name: modelData.icon
			icon.width: modelData.size
			icon.height: modelData.size
			icon.color: Material.color(modelData.color, Material.Shade200)

			onClicked: modelData.command()
		}
	}
}
