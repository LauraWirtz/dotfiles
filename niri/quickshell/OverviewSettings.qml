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

	ColumnLayout {
		width: root.width
		height: root.height

		Rectangle {
			id: bar
			Layout.alignment: Qt.AlignTop | Qt.AlignHCenter

			// anchors.horizontalCenter: parent.horizontalCenter
			// y: -height - 10
   //
			implicitWidth: children[0].implicitWidth
			// // implicitHeight: Math.min([root.height, children[0].implicitHeight + 40])
			implicitHeight: children[0].implicitHeight
			Layout.maximumHeight: root.height - 20

			bottomLeftRadius: 5
			bottomRightRadius: 5

			color: "#292c30"

			// states: [
			// 	State {
			// 		name: "OVERVIEW"
			// 		when: Niri.inOverview
			// 		PropertyChanges {bar.y: 0}
			// 	},
			// 	State {
			// 		name: "NOVERVIEW"
			// 		when: !Niri.inOverview
			// 		StateChangeScript { script: view.setCurrentIndex(0) }
			// 	}
			// ]
   //
			// transitions: Transition {
			// 	NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 150 }
			// }

			ColumnLayout {
				anchors.fill: parent
				implicitHeight: buttonRow.implicitHeight + view.implicitHeight

				RowLayout {
					id: buttonRow
					Layout.alignment: Qt.AlignRight

					TabBarButton {
						source: "/home/laura/.local/share/icons/Breeze-dark/apps/24@3x/cantata-symbolic.svg"
						show: view.currentIndex == 0
						onTapped: view.setCurrentIndex(0)
					}
					TabBarButton {
						source: "/home/laura/.local/share/icons/Breeze-dark/actions/24@3x/edit-find.svg"
						show: view.currentIndex == 1
						onTapped: view.setCurrentIndex(1)
					}
					TabBarButton {
						source: "/home/laura/.local/share/icons/Breeze-dark/status/24@3x/network-bluetooth-symbolic.svg"
						show: view.currentIndex == 2
						onTapped: view.setCurrentIndex(2)
					}
					TabBarButton {
						Layout.alignment: Qt.AlignRight
						source: "/home/laura/.local/share/icons/Breeze-dark/status/24@3x/network-wireless-on.svg"
						show: view.currentIndex == 3
						onTapped: view.setCurrentIndex(3)
					}
				}
				SwipeView {
					id: view
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.preferredHeight: children[currentIndex].prefferedHeight
					Layout.verticalStretchFactor: 1
					clip: true

					ColumnLayout {
						Layout.fillWidth: true
						RowLayout {
							Layout.fillWidth: true
							BrightnessWidget {}
							VolumeWidget {}
							KeyboardLayoutWidget {}
						}
						PlayerWidget {}
					}

					DesktopWidget {}

					BluetoothWidget {}
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
}
