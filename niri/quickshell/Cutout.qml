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
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: mouseArea; }

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
		anchors.bottomMargin: 12
		width: 64
		height: 32
		clip: true

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
					mouseArea.extended = !mouseArea.extended
			}
		}
		onWheel: event => {
			if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
			else { Niri.focusColumnRight() }
		}

		property bool extended: false

		states: [
			State {
				name: "OVERVIEW"
				when: (Niri.inOverview || mouseArea.containsMouse) && !mouseArea.extended
				PropertyChanges {mouseArea.anchors.bottomMargin: 6}
				PropertyChanges {mouseArea.width: 800}
				PropertyChanges {mouseArea.height: lowerContent.implicitHeight}
				PropertyChanges {overviewShape.shading: 1}
				PropertyChanges {clock.minimized: false}
				PropertyChanges {content.opacity: 1}
				PropertyChanges {content.enabled: true}
			},
			State {
				name: "EXTENDED"
				when: (Niri.inOverview || mouseArea.containsMouse) && mouseArea.extended
				extend: "OVERVIEW"
				PropertyChanges {mouseArea.height: content.implicitHeight}
				PropertyChanges {overviewShape.shading: 0.5}

			},
			State {
				name: "NOVERVIEW"
				when: !Niri.inOverview
				StateChangeScript { script: mouseArea.extended = false }
			}
		]
		transitions: [
			Transition {
				to: "OVERVIEW"
				ParallelAnimation {
					NumberAnimation { properties: "overviewShape.shading"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.width"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
					SequentialAnimation {
						PauseAnimation { duration: 75 }
						ParallelAnimation {
							NumberAnimation { properties: "content.opacity"; easing.type: Easing.OutQuad; duration: 50 }
						}
						PropertyAction { properties: "content.enabled"; value: true }
					}
				}
			},
			Transition {
				to: "EXTENDED"
				NumberAnimation { properties: "overviewShape.shading"; easing.type: Easing.OutQuad; duration: 150 }
				NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
			},
			Transition {
				to: "NOVERVIEW"
				ParallelAnimation {
					NumberAnimation { properties: "overviewShape.shading"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.width"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
					SequentialAnimation {
						PauseAnimation { duration: 25 }
						ParallelAnimation {
							NumberAnimation { properties: "content.opacity"; easing.type: Easing.OutQuad; duration: 50 }
						}
					}
				}
			},
		]

		Rectangle {
			Material.theme: Material.Dark
			Material.accent: Material.Blue
			id: overviewShape

			anchors.fill: parent
			radius: 26

			property real shading: 0.5

			gradient: Gradient {
				GradientStop { position: 0.0; color: Qt.lighter("#292c30", 1 + 0.5*overviewShape.shading) }
				GradientStop { position: 1.0; color: Qt.darker("#292c30", 1 + 0.5*overviewShape.shading) }
			}

			ColumnLayout {
				id: content
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				spacing: 0

				enabled: false
				opacity: 0

				RowLayout {
					id: upperContent
					Layout.margins: 16
					spacing: 16
					Loader {
						active: false
						sourceComponent: Component {
							DesktopWidget {
								model: [
									DesktopService.byId("net.kuribo64.melonDS"),
									DesktopService.byId("org.azahar_emu.Azahar"),
									DesktopService.byId("dolphin-emu"),
									DesktopService.byId("info.cemu.Cemu"),
									DesktopService.byId("Ryujinx"),
									DesktopService.byId("steam"),
								]
								orientation: ListView.Vertical
								display: AbstractButton.IconOnly
								interactive: false
								size: 64
							}
						}
						Timer {
							interval: 3000; running: true; repeat: false
							onTriggered: parent.active = true
						}
					}
					DesktopWidget {
						Layout.fillWidth: true
						Layout.fillHeight: true
						model: DesktopService.getFilteredEntries([
							"net.kuribo64.melonDS",
							"org.azahar_emu.Azahar",
							"dolphin-emu",
							"info.cemu.Cemu",
							"Ryujinx",
							"steam",
						])
						orientation: ListView.Vertical
						spacing: -8
					}
					ColumnLayout {
						Layout.fillWidth: true
						spacing: 16
						BluetoothWidget {}
						RowLayout {
							TlpWidget {}
							InputPlumberWidget {}
							KeyboardLayoutWidget {}
						}
						BluelightWidget {}
						BrightnessWidget {}
						VolumeWidget {}
						PlayerWidget {}
					}
				}
				RowLayout {
					id: lowerContent
					spacing: 0
					RoundButton {
						icon.name: "plasma-symbolic"
						icon.width: 24
						icon.height: 24
						text: "Overview "
						onClicked: Niri.toggleOverview()
					}
					Loader {
						active: root.screen.name == "eDP-1"
						sourceComponent: BatteryWidget { Layout.leftMargin: 12 }
					}
					Item {
						Layout.fillWidth: true
						Layout.horizontalStretchFactor: 1
					}
					WindowActionWidget {}
				}

			}

			ClockWidget {
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.bottom: parent.bottom
				id: clock
				minimized: true
			}
		}
	}
}
