// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

import QtQuick.Controls.Basic


Rectangle {
	id: keeb

	width: childrenRect.width + 2*KeyboardService.padding
	height: childrenRect.height + 2* KeyboardService.padding

	radius: KeyboardService.rounding + 2*KeyboardService.padding
	color: "#202326"

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
					id: print1
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
					text: modelData.label
					font.pixelSize: 20
					font.weight: 200
					color: "white"
					states: [
						State {
							name: "SHIFT"
							when: modelData.labelCaps && KeyboardService.isShift
							PropertyChanges {print1.opacity: 0}
							AnchorChanges {
								target: print1
								anchors.verticalCenter: undefined
								anchors.top: parent.top
							}
						}
					]
					transitions: [
						Transition {
							NumberAnimation { properties: "print1.opacity"; easing.type: Easing.InOutQuad; duration: 100 }
							AnchorAnimation { duration: 100}
						},
					]
				}
				Text {
					id: print2
					anchors.bottom: parent.bottom
					anchors.horizontalCenter: parent.horizontalCenter
					text: modelData.labelCaps
					font.pixelSize: 20
					font.weight: 200
					opacity: 0
					color: "white"
					states: [
						State {
							name: "SHIFT"
							when: modelData.labelCaps && KeyboardService.isShift
							PropertyChanges {print2.opacity: 1}
							AnchorChanges {
								target: print2
								anchors.bottom: undefined
								anchors.verticalCenter: parent.verticalCenter
							}
						}
					]
					transitions: [
						Transition {
							NumberAnimation { properties: "print2.opacity"; easing.type: Easing.InOutQuad; duration: 100 }
							AnchorAnimation { duration: 100}
						},
					]
				}
				PointHandler {
					id: cap
					onActiveChanged: {
						if(modelData.exec) modelData.exec(active)
						gateronMelodic.running = false
						gateronMelodic.command = KeyboardService.formKeypressCommand(modelData.key, active)
						gateronMelodic.running = true
					}
				}
				Process {
					id: gateronMelodic
					running: false
					stdout: SplitParser { onRead: data => console.log(data) }
				}
			}
		}
	}
	RectangularShadow {
		id: shadow
		anchors.fill: parent
		z: -1
		blur: 15
		spread: 0
		radius: parent.radius
	}
}
