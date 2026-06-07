// Bar.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./services"
import "./widgets"
import "./items"

import QtQuick.Controls.Material

PanelWindow {
	color: "transparent"

	anchors {
		bottom: true
		left: true
		right: true
	}
	implicitHeight: 40

	WlrLayershell.layer: WlrLayer.Top

	RowLayout {
		id: right

		anchors.right: parent.right
		anchors.top: parent.top
		anchors.rightMargin: 8

		spacing: 0

		MenuBarItem {
			Material.theme: Material.Dark
			Material.accent: Material.Pink
			icon.name: "input-keyboard-virtual"
			icon.width: 32
			icon.height: 32

			display: AbstractButton.IconOnly
			verticalPadding: 4
			horizontalPadding: 12
			hoverEnabled: false

			onClicked: Niri.spawn([ "pkill", "-SIGRTMIN", "wvkbd-deskintl" ])
		}
	}
}
