// Bar.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick
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

		IconButton {
			source: "/home/laura/.config/waybar/icons/devices/24/input-keyboard-virtual.svg"
			icon_width: 32
			icon_height: 32

			topPadding: 4
			bottomPadding: 4
			leftPadding: 8
			rightPadding: 8

			onTapped: Niri.spawn([ "pkill", "-SIGRTMIN", "wvkbd-deskintl" ])
		}

		IconButton {
			source: "/home/laura/.config/waybar/icons/actions/24/go-up.svg"
			icon_width: 32
			icon_height: 32

			topPadding: 4
			bottomPadding: 4
			leftPadding: 8
			rightPadding: 8

			onTapped: Niri.toggleOverview()
		}
	}
}
