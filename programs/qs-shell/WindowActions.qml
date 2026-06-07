// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "./services"
import "./widgets"
import "./items"

PanelWindow {
	id: root
	required property var modelData
	screen: modelData
	color: "transparent"

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Top

	mask: Region { item: bar }

	Rectangle {
		id: bar

		anchors.horizontalCenter: parent.horizontalCenter
		y: 1 * parent.height + 10

		implicitWidth: children[0].implicitWidth
		implicitHeight: children[0].implicitHeight

		radius: 8

		color: "#292c30"

		states: State {
			name: "OVERVIEW"
			when: (Niri.inOverview)
			PropertyChanges {bar.y: 0.75 * root.height - bar.height - 20}
		}

		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.OutQuad; duration: 150 }
		}

		WindowActionWidget {}

		RectangularShadow {
			anchors.fill: bar
			z: -1
			blur: 15
			spread: 0
			radius: 8
			cached: true
		}
	}
}
