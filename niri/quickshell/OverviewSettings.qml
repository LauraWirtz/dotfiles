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
		// implicitHeight: Math.min([root.height, children[0].implicitHeight + 40])
		implicitHeight: children[0].implicitHeight

		bottomLeftRadius: 5
		bottomRightRadius: 5

		color: "#292c30"

		states: [
			State {
				name: "OVERVIEW"
				when: Niri.inOverview
				PropertyChanges {bar.y: 0}
			},
			State {
				name: "NOVERVIEW"
				when: !Niri.inOverview
				StateChangeScript { script: buttonRow.state = "NONE" }
			}
		]

		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 150 }
		}

		ColumnLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.bottom: parent.bottom

			KeyboardLayoutWidget {
				Layout.alignment: Qt.AlignRight
			}

			RowLayout {
				BrightnessWidget {}
				VolumeWidget {}
			}
			RowLayout {
				id: buttonRow

				states: [
					State { name: "NONE" },
					State { name: "BLUETOOTH" },
					State { name: "WIFI" },
					State { name: "DESKTOP" }
				]

				IconButton {
					source: "/home/laura/.local/share/icons/Breeze-dark/apps/24@3x/cantata-symbolic.svg"
					icon_width: 32
					icon_height: 32

					topPadding: 8
					bottomPadding: 8
					leftPadding: 16
					rightPadding: 16

					onTapped: {buttonRow.state = "NONE"}
				}
				IconButton {
					source: "/home/laura/.local/share/icons/Breeze-dark/actions/24@3x/edit-find.svg"
					icon_width: 32
					icon_height: 32

					topPadding: 8
					bottomPadding: 8
					leftPadding: 16
					rightPadding: 16

					onTapped: {buttonRow.state = "DESKTOP"}
				}
				IconButton {
					source: "/home/laura/.local/share/icons/Breeze-dark/status/24@3x/network-bluetooth-symbolic.svg"
					icon_width: 32
					icon_height: 32

					topPadding: 8
					bottomPadding: 8
					leftPadding: 16
					rightPadding: 16

					onTapped: {buttonRow.state = "BLUETOOTH"}
				}
				IconButton {
					source: "/home/laura/.local/share/icons/Breeze-dark/status/24@3x/network-wireless-on.svg"
					icon_width: 32
					icon_height: 32

					topPadding: 8
					bottomPadding: 8
					leftPadding: 16
					rightPadding: 16

					onTapped: {buttonRow.state = "WIFI"}
				}
			}
			DesktopWidget {
				show: buttonRow.state == "DESKTOP"
				Layout.maximumHeight: 600
			}
			BluetoothWidget {
				show: buttonRow.state == "BLUETOOTH"
			}
			PlayerWidget {
				show: buttonRow.state == "NONE"
			}
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
