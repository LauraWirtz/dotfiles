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
				id: root

				property string click

				width: 2 * KeyboardService.scale - 2 * KeyboardService.padding
				height: 1 * KeyboardService.scale - 2 * KeyboardService.padding

				radius: KeyboardService.rounding
				color: "#292c30"

				border.color: "#292c30"
				border.width: 1

				states: [
					State {
						name: "ACTIVE"
						when: cap.active
						PropertyChanges {root.border.color: "#e93a9a"}
						PropertyChanges {root.color: "#462e40"}
					}
				]
				transitions: [
					Transition {
						from: "ACTIVE"
						ColorAnimation { properties: "root.border.color"; easing.type: Easing.OutQuad; duration: 100 }
						ColorAnimation { properties: "root.color"; easing.type: Easing.OutQuad; duration: 100 }
					},
				]
				PointHandler {
					id: cap
					onActiveChanged: {
							gateronMelodic.running = false
							gateronMelodic.command = KeyboardService.formMouseclickCommand(root.click, active)
							gateronMelodic.running = true
					}
				}
				Process {
					id: gateronMelodic
					running: false
					stdout: SplitParser { onRead: data => console.log(data) }
				}
			}
