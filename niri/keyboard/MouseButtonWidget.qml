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

	property string click

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

			Rectangle {
				id: key
				x: 0 * KeyboardService.scale + KeyboardService.padding
				y: 0 * KeyboardService.scale + KeyboardService.padding
				width: 1.5 * KeyboardService.scale - 2 * KeyboardService.padding
				height: 2 * KeyboardService.scale - 2 * KeyboardService.padding

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
				PointHandler {
					id: cap
					onActiveChanged: {
							gateronMelodic.running = false
							gateronMelodic.command = KeyboardService.formMouseclickCommand(keeb.click, active)
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
	RectangularShadow {
		id: shadow
		anchors.fill: parent
		z: -1
		blur: 15
		spread: 0
		radius: parent.radius
	}
}
