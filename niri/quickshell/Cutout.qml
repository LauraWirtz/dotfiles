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
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: cutout }

	implicitHeight: 40

	Rectangle {
		id: cutout

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top

		width: 120
		height: 24

		bottomLeftRadius: 15
		bottomRightRadius: 15

		color: "black"


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
	RowLayout {
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: -7

		ClockWidget {}
		BatteryWidget {}
	}
}
