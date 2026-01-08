// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "./items"
import "./services"
import "./widgets"

import QtQuick.Controls.Basic

PanelWindow {
	id:root
	color: "transparent"

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	mask: Region { item: keeb }


	Rectangle {
		id: keeb
		// visible: KeyboardService.visible
		// enabled: KeyboardService.visible

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: -height

		width: childrenRect.width + 2*KeyboardService.padding
		height: childrenRect.height + 2* KeyboardService.padding

		radius: KeyboardService.rounding + 2*KeyboardService.padding
		color: "#202326"

		states: [
			State {
				name: "VISIBLE"
				when: KeyboardService.visible
				PropertyChanges {keeb.anchors.bottomMargin: 40}
				PropertyChanges {shadow.visible: true}
			}
		]
		transitions: [
			Transition {
				to: "VISIBLE"
				SequentialAnimation{
					PropertyAction { target: shadow; property: "visible"; value: true }
					NumberAnimation { properties: "keeb.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 100 }
				}
			},
			Transition {
				from: "VISIBLE"
				SequentialAnimation{
					NumberAnimation { properties: "keeb.anchors.bottomMargin"; easing.type: Easing.InQuad; duration: 100 }
					PropertyAction { target: shadow; property: "visible"; value: false }
				}
			},
		]

		Item{
			id: plate
			x: KeyboardService.padding
			y: KeyboardService.padding

			width: childrenRect.width
			height: childrenRect.height

			Repeater {
				model: KeyboardService.layout
				Rectangle {
					id: key
					x: modelData.x * KeyboardService.scale + KeyboardService.padding
					y: modelData.y * KeyboardService.scale + KeyboardService.padding
					width: modelData.width * KeyboardService.scale - 2 * KeyboardService.padding
					height: modelData.height * KeyboardService.scale - 2 * KeyboardService.padding

					radius: KeyboardService.rounding
					color: "#292c30"

					border.color: "#292c30"
					border.width: 1

					states: [
						State {
							name: "ACTIVE"
							when: cap.active
							PropertyChanges {key.border.color: "#e93a9a"}
							PropertyChanges {key.color: "#462e40"}
						}
					]
					transitions: [
						Transition {
							from: "ACTIVE"
							ColorAnimation { properties: "key.border.color"; easing.type: Easing.OutQuad; duration: 100 }
							ColorAnimation { properties: "key.color"; easing.type: Easing.OutQuad; duration: 100 }
						},
					]

					Text {
						anchors.centerIn: parent
						text: KeyboardService.isShift ? modelData.labelCaps : modelData.label
						color: "white"

					}
					PointHandler {
						id: cap
						onActiveChanged: {
							exec.running = false
							exec.command = KeyboardService.formKeypressCommand(modelData.key, active)
							exec.running = true
						}
					}
					Process {
						id: exec
						running: false
						stdout: SplitParser { onRead: data => console.log(data) }
					}
				}
			}
		}
		RectangularShadow {
			id: shadow
			anchors.fill: parent
			visible: false
			z: -1
			blur: 15
			spread: 0
			radius: parent.radius
		}
	}
}
