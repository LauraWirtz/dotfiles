// Bar.qml
import Quickshell
import Quickshell.Io
import QtQuick
import "./items"

Rectangle {
	id: keeb

	width: childrenRect.width + 2*KeyboardService.padding
	height: childrenRect.height + 2* KeyboardService.padding

	// radius: KeyboardService.rounding + 2*KeyboardService.padding
	color: "#202326"

	Item{
		id: plate
		x: KeyboardService.padding
		y: KeyboardService.padding

		width: childrenRect.width
		height: childrenRect.height

		Repeater {
			model: KeyboardService.layout
			KeyboardButton {
				id: key
				x: modelData.x * KeyboardService.scale
				y: modelData.y * KeyboardService.scale
				width: modelData.width * KeyboardService.scale - 1 * KeyboardService.padding
				height: modelData.height * KeyboardService.scale - 1 * KeyboardService.padding

				state: key.pressed ? "ACTIVE" : ""

				onPressedChanged: {
					if(modelData.exec) modelData.exec(pressed)
						gateronMelodic.running = false
						gateronMelodic.command = KeyboardService.formKeypressCommand(modelData.key, pressed)
						gateronMelodic.running = true
				}

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
							when: modelData.labelCaps != undefined && KeyboardService.isShift
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
				Loader{
					anchors.fill: parent
					active: modelData.labelCaps != undefined
					sourceComponent: Item {
						anchors.fill: parent
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
									when: KeyboardService.isShift
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
					}
				}
				Process {
					id: gateronMelodic
					running: false
				}
				Component.onCompleted: {
					gateronMelodic.running = false
					gateronMelodic.command = KeyboardService.formKeypressCommand(modelData.key, false)
					gateronMelodic.running = true
				}
			}
		}
	}
}
