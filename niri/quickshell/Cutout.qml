// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import "./items"
import "./services"
import "./widgets"

import QtQuick.Controls.Material

PanelWindow {
	id: root
	required property var modelData
	screen: modelData

	color: "transparent"

	anchors {
		// top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: mouseArea; }
	// implicitWidth: 1000
	implicitHeight: 100

	RectangularShadow {
		id: overviewShadow
		anchors.fill: mouseArea
		z: -1
		blur: 20
		spread: 0
		radius: overviewShape.radius
		offset.x: 0
		offset.y: 0
	}
	MouseArea {
		id: mouseArea
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 16 - height / 4
		width: 64
		height: 32

		acceptedButtons: Qt.LeftButton | Qt.BackButton | Qt.ForwardButton
		hoverEnabled: true

		onClicked: event => {
			switch (event.button) {
				case Qt.BackButton:
					Niri.focusWorkspaceDown();
					break;
				case Qt.ForwardButton:
					Niri.focusWorkspaceUp();
					break;
				default:
					Niri.toggleOverview()
			}
		}
		onWheel: event => {
			if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
			else { Niri.focusColumnRight() }
		}

		Rectangle {
			Material.theme: Material.Dark
			Material.accent: Material.Blue
			id: overviewShape

			anchors.fill: parent
			radius: Math.min(width, height) / 2

			property real shading: 0.5

			gradient: Gradient {
				GradientStop { position: 0.0; color: Qt.lighter("#292c30", 1 + 0.5*overviewShape.shading) }
				GradientStop { position: 1.0; color: Qt.darker("#292c30", 1 + 0.5*overviewShape.shading) }
			}

			states: [
				State {
					name: "OVERVIEW"
					when: Niri.inOverview || mouseArea.containsMouse || PopupService.currentPopup != ""
					// PropertyChanges {overviewShape.anchors.bottomMargin: 0}
					PropertyChanges {mouseArea.width: 700}
					PropertyChanges {mouseArea.height: overviewShape.children[2].implicitHeight}
					PropertyChanges {overviewShape.shading: 1}
					PropertyChanges {clock.minimized: false}
					PropertyChanges {leftIcons.opacity: 1}
					PropertyChanges {rightIcons.opacity: 1}
					PropertyChanges {leftIcons.enabled: true}
					PropertyChanges {rightIcons.enabled: true}
				},
				State {
					name: "NOVERVIEW"
					when: !Niri.inOverview
					StateChangeScript { script: PopupService.currentPopup = "" }
				}
			]
			transitions: [
				Transition {
					to: "OVERVIEW"
					ParallelAnimation {
						NumberAnimation { properties: "overviewShape.shading"; easing.type: Easing.OutQuad; duration: 150 }
						NumberAnimation { properties: "mouseArea.width"; easing.type: Easing.OutQuad; duration: 150 }
						NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
						SequentialAnimation {
							PauseAnimation { duration: 75 }
							ParallelAnimation {
								NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.OutQuad; duration: 50 }
								NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.OutQuad; duration: 50 }
							}
							PropertyAction { properties: "leftIcons.enabled"; value: true }
							PropertyAction { properties: "rightIcons.enabled"; value: true }
						}
					}
				},
				Transition {
					from: "OVERVIEW"
					ParallelAnimation {
						NumberAnimation { properties: "overviewShape.shading"; easing.type: Easing.OutQuad; duration: 150 }
						NumberAnimation { properties: "mouseArea.width"; easing.type: Easing.OutQuad; duration: 150 }
						NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
						SequentialAnimation {
							PauseAnimation { duration: 25 }
							ParallelAnimation {
								NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.OutQuad; duration: 50 }
								NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.OutQuad; duration: 50 }
							}
						}
					}
				},
			]

			ClockWidget {
				anchors.centerIn: parent
				id: clock
				minimized: true
			}
			RowLayout {
				id: leftIcons
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
				anchors.leftMargin: 0
				spacing: 0
				opacity: 0
				enabled: false

				ApplicationMenuWidget {screen: root.screen.name}
				Loader {
					active: root.screen.name == "DP-1" || root.screen.name == "eDP-1"
					sourceComponent: BluetoothMenuWidget {}
				}
				Loader {
					active: root.screen.name == "DP-1" || root.screen.name == "eDP-1"
					sourceComponent:
					MenuWithButton {
						name: "sunsetr"
						icon.name: "redshift-status-on"
						color: Material.Yellow
						content: BluelightWidget {anchors.centerIn: parent}
					}
				}
				Loader {
					active: root.screen.name == "DP-1" || root.screen.name == "eDP-1"
					sourceComponent: TlpWidget {}
				}
				Loader {
					active: root.screen.name == "eDP-1"
					sourceComponent: BatteryWidget { Layout.leftMargin: 12 }
				}
			}
			RowLayout {
				id: rightIcons
				anchors.right: parent.right
				anchors.rightMargin: 0
				anchors.verticalCenter: parent.verticalCenter
				spacing: 0
				opacity: 0
				enabled: false

				WindowActionWidget {}
			}
		}
	}
}
