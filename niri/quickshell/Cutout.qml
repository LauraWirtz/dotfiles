// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "./items"
import "./services"
import "./widgets"

PanelWindow {
	color: "transparent"

	anchors {
		top: true
		left: true
		right: true
	}
	// exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: cutout }

	implicitHeight: 40

	Rectangle {
		id: cutout

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: -4

		implicitWidth: children[0].implicitWidth + 24
		implicitHeight: children[0].implicitHeight

		bottomLeftRadius: 15
		bottomRightRadius: 15

		color: "black"

		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 2

			ClockWidget {}
			BatteryWidget {}
		}

		TapHandler {
			id: mouseHandler
			acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
			gesturePolicy: TapHandler.ReleaseWithinBounds
			onTapped: Niri.toggleOverview()
		}
		TapHandler {
			id: tapHandler
			acceptedDevices: PointerDevice.TouchScreen
			gesturePolicy: TapHandler.ReleaseWithinBounds
			onTapped: Niri.spawn([ "pkill", "-SIGRTMIN", "wvkbd-deskintl" ])
		}

		GestureHandler {
			function onDown() { Niri.openOverview() }
			function onLeft() { Niri.focusColumnRight() }
			function onRight() { Niri.focusColumnLeft() }
		}
	}
}
