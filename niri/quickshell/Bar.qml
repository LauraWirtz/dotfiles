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

PanelWindow {
	color: "transparent"

	anchors {
		top: true
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

		Button {
			icon.name: "input-keyboard-virtual"
			icon.width: 32
			icon.height: 32

			background: {}

			display: AbstractButton.IconOnly
			verticalPadding: 4
			horizontalPadding: 8
			flat: true
			hoverEnabled: false

			onClicked: Niri.spawn([ "pkill", "-SIGRTMIN", "wvkbd-deskintl" ])
		}
	}
}
