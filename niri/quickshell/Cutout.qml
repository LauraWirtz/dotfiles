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

	property bool batteryEnabled: false

	color: "transparent"

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: overviewShape; Region { item: menu } }

	implicitHeight: 40

	Shape {
		id: cutoutShape
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		width: 150
		height: 25
		preferredRendererType: Shape.CurveRenderer

		ShapePath {
			strokeWidth: -1
			fillColor: "black"

			startX: 0; startY: 25
			PathCubic {
				x: 50; y: 0
				control1X: 25; control1Y: 25
				control2X: 25; control2Y: 0
			}
			PathLine {
				x: cutoutShape.width - 50
				y: 0
			}
			PathCubic {
				x: cutoutShape.width; y: 25
				control1X: cutoutShape.width - 25; control1Y: 0
				control2X: cutoutShape.width - 25; control2Y: 25
			}
		}
	}
	Rectangle {
		Material.theme: Material.Dark
		Material.accent: Material.Pink
		id: overviewShape
		color: "black"
		topLeftRadius: 8
		topRightRadius: 8

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		width: 90
		height: 20
		Behavior on width { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
		Behavior on height { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }

		states: [
			State {
				name: "OVERVIEW"
				when: Niri.inOverview
				PropertyChanges {overviewShape.width: 650}
				PropertyChanges {overviewShape.height: 55}
				PropertyChanges {leftIcons.opacity: 1}
				PropertyChanges {rightIcons.opacity: 1}
				PropertyChanges {overviewShadow.opacity: 1}
			},
			State {
				name: "NOVERVIEW"
				when: !Niri.inOverview
				StateChangeScript { script: view.currentIndex = -1 }
			}
		]
		transitions: [
			Transition {
				to: "OVERVIEW"
				SequentialAnimation {
					PauseAnimation { duration: 75 }
					ParallelAnimation {
						NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.InOutQuad; duration: 75 }
						NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.InOutQuad; duration: 75 }
						NumberAnimation { properties: "overviewShadow.opacity"; easing.type: Easing.InOutQuad; duration: 75 }
					}
				}
			},
			Transition {
				from: "OVERVIEW"
				NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.InOutQuad; duration: 75 }
				NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.InOutQuad; duration: 75 }
				NumberAnimation { properties: "overviewShadow.opacity"; easing.type: Easing.InOutQuad; duration: 75 }
			},
		]
		RowLayout {
			id: leftIcons
			anchors.fill: parent
			spacing: 0
			opacity: Niri.inOverview ? 1 : 0
			RoundButton {
				icon.name: "edit-find"
				icon.width: 32
				icon.height: 32
				flat: true
				checkable: true
				checked: view.currentIndex == 0
				onClicked: view.currentIndex == 0 ? view.setCurrentIndex(-1) : view.setCurrentIndex(0)
			}
			Loader {
				active: root.screen.name == "DP-1"
				sourceComponent:
					RoundButton {
						icon.name: "applications-system-symbolic"
						icon.width: 32
						icon.height: 32
						flat: true
						checkable: true
						checked: view.currentIndex == 1
						onClicked: view.currentIndex == 1 ? view.setCurrentIndex(-1) : view.setCurrentIndex(1)
					}
			}
			Loader {
				active: root.screen.name == "DP-1"
				sourceComponent:
				RoundButton {
					icon.name: "network-bluetooth"
					icon.width: 32
					icon.height: 32
					flat: true
					checkable: true
					checked: view.currentIndex == 2
					onClicked: view.currentIndex == 2 ? view.setCurrentIndex(-1) : view.setCurrentIndex(2)
				}
			}
			MouseArea {
				Layout.fillWidth: true
				Layout.fillHeight: true
				onClicked: Niri.toggleOverview()
			}
			WindowActionWidget {
				id: rightIcons
				opacity: 0
			}
		}
	}
	Rectangle {
		id: menu
		anchors.left: overviewShape.left
		anchors.bottom: overviewShape.top
		implicitWidth: children[0].implicitWidth + 32
		implicitHeight: children[0].implicitHeight + 32
		color: "#292c30"
		visible: view.currentIndex != -1
		radius: 8

		SwipeView {
			id: view
			x: 16
			y: 16
			clip: true

			RowLayout {
				Layout.fillWidth: true
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
							]
							alignment: Qt.AlignHCenter
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
					model: DesktopService.getFilteredEntries([
						"net.kuribo64.melonDS",
						"org.azahar_emu.Azahar",
						"dolphin-emu",
						"info.cemu.Cemu",
						"Ryujinx",
					])
				}
			}
			Loader {
				active: root.screen.name == "DP-1"
				sourceComponent:
					ColumnLayout {
						spacing: 16
						VolumeWidget {}
						BrightnessWidget {}
						BluelightWidget {}
						RowLayout {
							spacing: 16
							KeyboardLayoutWidget {}
							InputPlumberWidget { Layout.fillWidth: false }
						}
						TlpWidget {}
						PlayerWidget {}
					}
			}
			Loader {
				active: root.screen.name == "DP-1"
				sourceComponent:
					BluetoothWidget {}
			}
		}
		RectangularShadow {
			anchors.fill: parent
			z: -1
			blur: 15
			spread: 0
			radius: 8
		}
	}

	Item {
		id: cutout

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom

		width: 100
		height: 25

		MouseArea {
			anchors.fill: parent
			id: mouseHandler
			onClicked: Niri.toggleOverview()
			onWheel: event => {
				if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
				else { Niri.focusColumnRight() }
			}
		}
		TapHandler {
			id: tapHandler
			acceptedDevices: PointerDevice.TouchScreen
			gesturePolicy: TapHandler.ReleaseWithinBounds
			onTapped: KeyboardService.toggle()
		}

		GestureHandler {
			function onUp() { Niri.openOverview(); KeyboardService.hide() }
			function onLeft() { Niri.focusColumnRight() }
			function onRight() { Niri.focusColumnLeft() }
		}
	}
	RowLayout {
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		spacing: 0

		ClockWidget {Layout.bottomMargin: -4}
		Loader {
			Layout.leftMargin:root.batteryEnabled ? 16 : 0
			active: root.batteryEnabled
			sourceComponent: BatteryWidget {}
		}

	}
}
