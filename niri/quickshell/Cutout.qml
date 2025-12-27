// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
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

	mask: Region { item: touch }

	implicitHeight: 40

	Rectangle {
		id: cutout

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: -6

		implicitWidth: children[0].implicitWidth + 24
		implicitHeight: children[0].implicitHeight + 4

		bottomLeftRadius: 15
		bottomRightRadius: 15

		color: "black"

		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top

			ClockWidget {}
			BatteryWidget {}
		}
	}

	Item {
		id: touch
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		width: cutout.implicitWidth
		height: 40

		TapHandler {
			id: tapHandler
			gesturePolicy: TapHandler.ReleaseWithinBounds
			onTapped: Niri.toggleOverview()
		}
	}
}
