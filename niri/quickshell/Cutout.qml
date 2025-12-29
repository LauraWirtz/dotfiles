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
		states: [
			State {
				name: "RIGHT"
				when: dragHandler.centroid.velocity.x > 1000
				StateChangeScript { script: {
					Niri.focusColumnLeft()
					dragHandler.enabled = false
				} }
			},
			State {
				name: "LEFT"
				when: dragHandler.centroid.velocity.x < -1000
				StateChangeScript { script: {
					Niri.focusColumnRight()
					dragHandler.enabled = false
				} }
			},
		]

		TapHandler {
			id: tapHandler
			gesturePolicy: TapHandler.ReleaseWithinBounds
			onTapped: Niri.toggleOverview()
		}
		DragHandler {
			id: dragHandler
			enabled: true
			onActiveChanged: enabled = active ? enabled : true
		}
	}
}
