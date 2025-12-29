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

import QtQuick.Controls.Material

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
		y: -height - 10

		implicitWidth: children[0].implicitWidth
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
				StateChangeScript { script: view.setCurrentIndex(0) }
			}
		]

		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 150 }
		}

		ColumnLayout {
			implicitHeight: buttonRow.implicitHeight + view.implicitHeight
			spacing: 0

			TabBar {
				id: buttonRow
				Layout.alignment: Qt.AlignRight
				spacing: 0
				Material.theme: Material.Dark
				Material.accent: Material.Pink

				TabButton {
					icon.name: "configure"
				}
				TabButton {
					icon.name: "edit-find"
				}
				TabButton {
					icon.name: "network-bluetooth-symbolic"
				}
				TabButton {
					icon.name: "network-wireless-on"
				}
			}
			Rectangle{
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.preferredHeight: children[0].preferredHeight
				Layout.maximumHeight: root.height - buttonRow.height - 20
				implicitHeight: children[0].implicitHeight
				implicitWidth: children[0].implicitWidth
				Layout.verticalStretchFactor: 1
				clip: true
				color: "#202326"
				bottomLeftRadius: 5
				bottomRightRadius: 5

				SwipeView {
					id: view
					currentIndex: buttonRow.currentIndex
					anchors.fill: parent
					Layout.preferredHeight: children[currentIndex].preferredHeight

					onCurrentIndexChanged: {
						buttonRow.currentIndex = currentIndex
					}

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
					Text {
						Layout.fillWidth: true
						text: "lorem ipsum"
					}
				}
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
