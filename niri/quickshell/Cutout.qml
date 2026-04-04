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
		opacity: 0
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
		anchors.bottomMargin: 11
		width: 64
		height: 26
		clip: true

		acceptedButtons: Qt.LeftButton | Qt.BackButton | Qt.ForwardButton
		hoverEnabled: root.screen.name != "eDP-1"

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
				PropertyChanges {mouseArea.anchors.bottomMargin: 3}
				PropertyChanges {mouseArea.width: content.implicitWidth}
				PropertyChanges {mouseArea.height: lowerContent.implicitHeight}
				PropertyChanges {overviewShape.upperColor: Qt.lighter("#292c30", 1.5)}
				PropertyChanges {overviewShape.lowerColor: Qt.darker("#292c30", 1.5)}
				PropertyChanges {cutoutItem.minimized: false}
				PropertyChanges {content.opacity: 1}
				PropertyChanges {content.enabled: true}
				PropertyChanges {overviewShadow.opacity: 1}
			},
			State {
				name: "EXTENDED"
				when: (Niri.inOverview || mouseArea.containsMouse) && mouseArea.extended
				extend: "OVERVIEW"
				PropertyChanges {mouseArea.height: content.implicitHeight}
				PropertyChanges {overviewShape.upperColor: Qt.lighter("#292c30", 1.25)}
				PropertyChanges {overviewShape.lowerColor: Qt.darker("#292c30", 1.25)}

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
					ColorAnimation { properties: "overviewShape.upperColor"; easing.type: Easing.OutQuad; duration: 150 }
					ColorAnimation { properties: "overviewShape.lowerColor"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.width"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "overviewShadow.opacity"; easing.type: Easing.OutQuad; duration: 150 }
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
				ColorAnimation { properties: "overviewShape.upperColor"; easing.type: Easing.OutQuad; duration: 150 }
				ColorAnimation { properties: "overviewShape.lowerColor"; easing.type: Easing.OutQuad; duration: 150 }
				NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
			},
			Transition {
				to: "NOVERVIEW"
				ParallelAnimation {
					ColorAnimation { properties: "overviewShape.upperColor"; easing.type: Easing.OutQuad; duration: 150 }
					ColorAnimation { properties: "overviewShape.lowerColor"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.width"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.height"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "mouseArea.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "overviewShadow.opacity"; easing.type: Easing.OutQuad; duration: 150 }
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

			property color upperColor: "black"
			property color lowerColor: "black"

			gradient: Gradient {
				GradientStop { position: 0.0; color: overviewShape.upperColor }
				GradientStop { position: 1.0; color: overviewShape.lowerColor }
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
									DesktopService.byId("steam"),
									DesktopService.byId("net.kuribo64.melonDS"),
									DesktopService.byId("org.azahar_emu.Azahar"),
									DesktopService.byId("dolphin-emu"),
									DesktopService.byId("info.cemu.Cemu"),
									DesktopService.byId("Ryujinx"),
								]
								orientation: ListView.Vertical
								display: AbstractButton.IconOnly
								interactive: false
								size: 64
								spacing: -8
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
							"steam",
							"net.kuribo64.melonDS",
							"org.azahar_emu.Azahar",
							"dolphin-emu",
							"info.cemu.Cemu",
							"Ryujinx",
						])
						orientation: ListView.Vertical
						interactive: false
						spacing: -8
					}
					Rectangle {
						Layout.fillHeight: true
						Layout.leftMargin: -4
						Layout.rightMargin: -4
						width: 2
						radius: 1
						color: "#22ffffff"

					}
					ColumnLayout {
						Layout.fillWidth: true
						spacing: 16
						BluetoothWidget {}
						RowLayout {
							InputPlumberWidget {}
							KeyboardLayoutWidget {}
						}
						// BluelightWidget {}
						BrightnessWidget {}
						VolumeWidget {}
						PlayerWidget {}
					}
				}
				RowLayout {
					id: lowerContent
					spacing: 0
					RoundButton {
						icon.name: "user-home-symbolic"
						icon.width: 24
						icon.height: 24
						text: "Overview  "
						onClicked: Niri.toggleOverview()
					}
					TlpWidget {}
					Item {
						Layout.fillWidth: true
						Layout.horizontalStretchFactor: 1
					}
					WindowActionWidget {}
				}

			}
			Item{
				id: cutoutItem
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.bottom: parent.bottom
				height: minimized ? 26 : 56

				property bool minimized: true

				Behavior on height { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }

				Loader {
					anchors.centerIn: parent
					active: root.screen.name == "eDP-1"
					sourceComponent: BatteryWidget {
						minimized: cutoutItem.minimized
					}
				}
				Loader {
					anchors.centerIn: parent
					active: root.screen.name != "eDP-1"
					sourceComponent: ClockWidget {
						minimized: cutoutItem.minimized
					}
				}
			}
		}
	}
}
