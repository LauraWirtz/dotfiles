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

	property var windowModelData

	property var buttonsModel: [
		{ icon: "window-minimize-pip", size: 24, color: Material.Teal, command: windowModelData=>Niri.toggleWindowFloating(windowModelData.id) },
		{ icon: "view-fullscreen-symbolic", size: 24, color: Material.Green, command: windowModelData=>Niri.fullscreenWindow(windowModelData.id) },
		{ icon: "kdenlive-slip", size: 24, color: Material.Yellow, command: windowModelData=>Niri.centerWindow(windowModelData.id) },
		{ icon: "window-maximize", size: 24, color: Material.Orange, command: windowModelData=>Niri.switchPresetWindowWidth(windowModelData.id) },
		{ icon: "window-close", size: 24, color: Material.Red, command: windowModelData=>Niri.closeWindow(windowModelData.id) },
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

			onClicked: modelData.command(windowModelData)
		}
	}
}
