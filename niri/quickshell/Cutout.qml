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

	mask: Region { item: overviewShape; Region { item: menu; Region { item: windowActions } } }

	implicitHeight: 40

	Shape {
		id: cutoutShape
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		width: 100
		height: 22
		preferredRendererType: Shape.CurveRenderer

		ShapePath {
			id: cutoutPath
			strokeWidth: 0
			strokeColor: "#3daee9"
			fillColor: "black"

			Behavior on strokeWidth { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on fillColor { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }

			startX: 0; startY: 22
			PathCubic {
				x: 32; y: 0
				control1X: 16; control1Y: 22
				control2X: 16; control2Y: 0
			}
			PathLine {
				x: cutoutShape.width - 32
				y: 0
			}
			PathCubic {
				x: cutoutShape.width; y: 22
				control1X: cutoutShape.width - 16; control1Y: 0
				control2X: cutoutShape.width - 16; control2Y: 22
			}
		}
	}
	Rectangle {
		Material.theme: Material.Dark
		Material.accent: Material.Blue
		id: overviewShape

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: -32
		width: clock.width
		height: children[1].implicitHeight

		radius: 8
		color: "transparent"

		states: [
			State {
				name: "OVERVIEW"
				when: Niri.inOverview
				PropertyChanges {overviewShape.width: 800}
				PropertyChanges {overviewShape.anchors.bottomMargin: 0}
				PropertyChanges {overviewShape.color: "#292c30"}
				PropertyChanges {overviewShadow.opacity: 1}
				PropertyChanges {leftIcons.opacity: 1}
				PropertyChanges {centerIcons.opacity: 1}
				PropertyChanges {rightIcons.opacity: 1}
				PropertyChanges {leftIcons.enabled: true}
				PropertyChanges {centerIcons.enabled: true}
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
				PropertyAction { properties: "overviewShape.color"; value: "black" }
				PropertyAction { properties: "overviewShape.border.color"; value: "black" }
				ColorAnimation { properties: "overviewShape.color"; easing.type: Easing.OutQuad; duration: 150 }
				ColorAnimation { properties: "overviewShape.border.color"; easing.type: Easing.OutQuad; duration: 150 }
				NumberAnimation { properties: "overviewShape.width"; easing.type: Easing.OutQuad; duration: 150 }
				NumberAnimation { properties: "overviewShape.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
				SequentialAnimation {
					PauseAnimation { duration: 75 }
					ParallelAnimation {
						NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
						NumberAnimation { properties: "centerIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
						NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
					}
				}
			},
			Transition {
				from: "OVERVIEW"
				ColorAnimation { properties: "overviewShape.color"; to: "black"; easing.type: Easing.OutQuad; duration: 150 }
				ColorAnimation { properties: "overviewShape.border.color"; to: "black"; easing.type: Easing.OutQuad; duration: 150 }
				NumberAnimation { properties: "overviewShape.width"; easing.type: Easing.OutQuad; duration: 150 }
				NumberAnimation { properties: "overviewShape.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 150 }
				NumberAnimation { properties: "leftIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
				NumberAnimation { properties: "centerIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
				NumberAnimation { properties: "rightIcons.opacity"; easing.type: Easing.OutQuad; duration: 75 }
			},
		]
		MouseArea {
			anchors.fill: parent
			onClicked: Niri.toggleOverview()
			onWheel: event => {
				if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
				else { Niri.focusColumnRight() }
			}
		}
		RowLayout {
			id: leftIcons
			anchors.left: parent.left
			spacing: 0
			opacity: 0
			enabled: false

			ApplicationMenuWidget {}
			WindowActionWidget {}
		}
		RowLayout {
			anchors.right: parent.right
			anchors.rightMargin: Niri.inOverview ? 16 : 0
			anchors.verticalCenter: parent.verticalCenter
			spacing: 0
			RowLayout {
				id: rightIcons
				opacity: 0
				spacing: 0
				enabled: false
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
					Layout.rightMargin: 16
					active: root.screen.name == "DP-1" || root.screen.name == "eDP-1"
					sourceComponent: BatteryWidget {}
				}
			}
			ClockWidget { id: clock }
		}
		RectangularShadow {
			id: overviewShadow
			anchors.fill: parent
			z: -1
			opacity: 0
			blur: 15
			spread: 0
			radius: 8
		}
	}
}
