// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Controls.Material

RowLayout {
	id: root
	Material.theme: Material.Dark
	Material.accent: Material.Pink

	property var buttonsModel: [
		{ icon: "window-minimize-pip", command: ()=>Niri.toggleWindowFloating() },
		{ icon: "view-fullscreen", command: ()=>Niri.fullscreenWindow() },
		{ icon: "view-file-columns", command: ()=>Niri.centerColumn() },
		{ icon: "view-split-left-right", command: ()=>Niri.switchPresetColumnWidth() },
		{ icon: "application-exit", command: ()=>Niri.closeWindow() },
	]

	Repeater {
		model: buttonsModel
		MenuBarItem {
			id: delegate
			icon.name: modelData.icon
			icon.color: "transparent"
			icon.width: 48
			icon.height: 48

			horizontalPadding: 12
			verticalPadding: 0

			onClicked: modelData.command()
		}
	}
}
