// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import "./items"
import "./services"
import "./widgets"

PanelWindow {
	color: "transparent"

	anchors {
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: cutout }

	implicitHeight: 40

	Shape {
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		width: 300
		height: 28
		ShapePath {
			strokeWidth: -1
			fillColor: "black"

			startX: 0; startY: 28
			PathCubic {
				x: 80; y: 0
				control1X: 50; control1Y: 28
				control2X: 50; control2Y: 0
			}
			PathLine { x: 220; y: 0 }
			PathCubic {
				x: 300; y: 28
				control1X: 250; control1Y: 0
				control2X: 250; control2Y: 28
			}
		}
	}

	Item {
		id: cutout

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom

		width: 200
		height: 24

		TapHandler {
			id: mouseHandler
			gesturePolicy: TapHandler.ReleaseWithinBounds
			onTapped: Niri.toggleOverview()
		}

		GestureHandler {
			function onUp() { Niri.openOverview() }
			function onLeft() { Niri.focusColumnRight() }
			function onRight() { Niri.focusColumnLeft() }
		}
	}
	RowLayout {
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: -4

		ClockWidget {}
		BatteryWidget {}
	}
}
