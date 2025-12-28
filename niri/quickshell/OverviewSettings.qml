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
		y: -implicitHeight - 10

		implicitWidth: children[0].implicitWidth
		implicitHeight: children[0].implicitHeight + 40

		bottomLeftRadius: 5
		bottomRightRadius: 5

		color: "#292c30"

		states: State {
			name: "OVERVIEW"
			when: (Niri.inOverview)
			PropertyChanges {bar.y: 0}
		}

		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 150 }
		}

		ColumnLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom

			RowLayout {
				BrightnessWidget {}
				VolumeWidget {}
			}
			RowLayout {
				IconButton {
					source: "/home/laura/.local/share/icons/Breeze-dark/status/24@2x/network-bluetooth-symbolic.svg"
					icon_width: 24
					icon_height: 24

					topPadding: 8
					bottomPadding: 8
					leftPadding: 16
					rightPadding: 16

					onTapped: {}
				}
				IconButton {
					source: "/home/laura/.local/share/icons/Breeze-dark/status/24@2x/network-wireless-on.svg"
					icon_width: 24
					icon_height: 24

					topPadding: 8
					bottomPadding: 8
					leftPadding: 16
					rightPadding: 16

					onTapped: {}
				}
				KeyboardLayoutWidget {}
			}
			BluetoothWidget {}
		}

		RectangularShadow {
			anchors.fill: bar
			z: -1
			blur: 15
			spread: 0
			radius: 5
		}
	}
}
