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
		// left: true
		// right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: mouseArea; }
	implicitWidth: 1000
	implicitHeight: 100

	Shape {
		id: cutoutShape
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: overviewShape.bottom
		width: 800
		height: overviewShape.height
		preferredRendererType: Shape.CurveRenderer

		ShapePath {
			id: cutoutPath
			strokeWidth: -1
			fillColor: "black"

			property real outerX: 340

			property real handle1X: 360
			property real handle1Y: 29

			property real handle2X: 360
			property real innerX: 380

			property real lowerY: 29
			property real upperY: 5

			Behavior on fillColor { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }

			Behavior on outerX { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on handle1X { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on handle1Y { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on handle2X { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on handle1X { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on innerX { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on upperY { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }

			startX: cutoutPath.outerX; startY: cutoutPath.lowerY

			PathCubic {
				x: cutoutPath.innerX; y: cutoutPath.upperY
				control1X: cutoutPath.handle1X; control1Y: cutoutPath.handle1Y
				control2X: cutoutPath.handle2X; control2Y: cutoutPath.upperY
			}
			PathLine {
				x: cutoutShape.width - cutoutPath.innerX
				y: cutoutPath.upperY
			}
			PathCubic {
				x: cutoutShape.width - cutoutPath.outerX; y: cutoutPath.lowerY
				control1X: cutoutShape.width - cutoutPath.handle2X; control1Y: cutoutPath.upperY
				control2X: cutoutShape.width - cutoutPath.handle1X; control2Y: cutoutPath.handle1Y
			}
			PathLine {
				x: cutoutShape.width - cutoutPath.outerX
				y: cutoutShape.height - 8
			}
			PathArc {
				x: cutoutShape.width - cutoutPath.outerX - 8
				y: cutoutShape.height
				radiusX: 8
				radiusY: 8
			}
			PathLine {
				x: cutoutPath.outerX + 8
				y: cutoutShape.height
			}
			PathArc {
				x: cutoutPath.outerX
				y: cutoutShape.height - 8
				radiusX: 8
				radiusY: 8
			}
			PathLine {
				x: cutoutPath.outerX
				y: cutoutPath.lowerY
			}
		}
	}
	Item {
		Material.theme: Material.Dark
		Material.accent: Material.Blue
		id: overviewShape

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 29 - height
		width: clock.implicitWidth
		height: children[0].implicitHeight

		states: [
			State {
				name: "OVERVIEW"
				when: Niri.inOverview
				PropertyChanges {overviewShape.anchors.bottomMargin: 16}
				PropertyChanges {overviewShape.width: 800}
				PropertyChanges {overviewShadow.visible: true}
				PropertyChanges {leftIcons.opacity: 1}
				PropertyChanges {rightIcons.opacity: 1}
				PropertyChanges {leftIcons.enabled: true}
				PropertyChanges {rightIcons.enabled: true}
				PropertyChanges {systemtray.anchors.rightMargin: 12}
				PropertyChanges {cutoutPath.fillColor: "#292c30"}
				PropertyChanges {cutoutPath.outerX: 0}
				PropertyChanges {cutoutPath.handle1X: 0}
				PropertyChanges {cutoutPath.handle1Y: 0}
				PropertyChanges {cutoutPath.handle2X: 0}
				PropertyChanges {cutoutPath.innerX: 20}
				PropertyChanges {cutoutPath.lowerY: 20}
				PropertyChanges {cutoutPath.upperY: 0}
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
					NumberAnimation { properties: "overviewShape.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "overviewShape.width"; easing.type: Easing.OutQuad; duration: 150 }
					SequentialAnimation {
						PauseAnimation { duration: 75 }
						ParallelAnimation {
							NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
							NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
						}
						PropertyAction { properties: "leftIcons.enabled"; value: true }
						PropertyAction { properties: "rightIcons.enabled"; value: true }
					}
				}
			},
			Transition {
				from: "OVERVIEW"
				ParallelAnimation {
					NumberAnimation { properties: "overviewShape.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "overviewShape.width"; easing.type: Easing.OutQuad; duration: 150 }
					NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
					NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
				}
			},
		]
		RowLayout {
			id: leftIcons
			anchors.left: parent.left
			spacing: 0
			opacity: 0
			enabled: false

			WindowActionWidget {}
		}
		RowLayout {
			id: systemtray
			anchors.right: parent.right
			anchors.rightMargin: 0
			anchors.verticalCenter: parent.verticalCenter
			spacing: 0
			RowLayout {
				id: rightIcons
				spacing: 0
				opacity: 0
				enabled: false
				Loader {
					active: root.screen.name == "DP-1" || root.screen.name == "eDP-1"
					sourceComponent: ApplicationMenuWidget {}
				}
				Loader {
					active: root.screen.name == "DP-1" || root.screen.name == "eDP-1"
					sourceComponent: SettingsMenuWidget {}
				}
				Loader {
					active: root.screen.name == "DP-1" || root.screen.name == "eDP-1"
					sourceComponent: BluetoothMenuWidget {}
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
			ClockWidget {
				Layout.leftMargin: 12
				id: clock
			}
		}
	}
	RectangularShadow {
		id: overviewShadow
		anchors.fill: overviewShape
		z: -1
		visible: false
		blur: 30
		spread: 0
		radius: 8
		offset.x: 5
		offset.y: 5
	}
	MouseArea {
		id: mouseArea
		anchors.fill: overviewShape
		anchors.bottomMargin: -16
		z: -1
		onClicked: Niri.toggleOverview()
		onWheel: event => {
			if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
			else { Niri.focusColumnRight() }
		}
	}
}
