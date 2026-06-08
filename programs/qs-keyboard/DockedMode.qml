// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import "./items"


PanelWindow {
	id:root
	color: "#292c30"
	property var screen: Quickshell.screens[0]

	// anchors.left: true
	anchors.bottom: true
	margins.bottom: 10

	// exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "qs-keyboard"

	implicitWidth: keeb.width
	implicitHeight: keeb.height

	visible: KeyboardService.visible && KeyboardService.mode == KeyboardService.Docked

	KeyboardWidget {
		id: keeb

		KeyboardButton {
			id: handle
			x: 14 * KeyboardService.scale + 1 * KeyboardService.padding
			y: 1 * KeyboardService.padding
			width: KeyboardService.scale - KeyboardService.padding
			height: KeyboardService.scale - KeyboardService.padding

			icon.name: "input-keyboard-virtual-show"
			icon.color: "white"
			icon.width: 32
			icon.height: 32

			state: pressed ? "ACTIVE" : ""
			onClicked: KeyboardService.mode = KeyboardService.Floating
		}
	}
}
