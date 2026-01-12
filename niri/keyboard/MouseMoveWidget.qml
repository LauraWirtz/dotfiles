// Bar.qml
import Quickshell
import Quickshell.Io
import QtQuick


	Rectangle {
		id: root

		width: 5 * KeyboardService.scale - 2*KeyboardService.padding
		height: 4 * KeyboardService.scale - 2* KeyboardService.padding

		readonly property real boundX: root.width
		readonly property real boundY: root.height
		readonly property real dragFactor: 0.666

		readonly property real flickThreshold: 300
		readonly property real flickFactor: 1
		readonly property real flickDecel: 0.98

		property real prevX: 0
		property real prevY: 0
		property real errorX: 0
		property real errorY: 0
		property real velocityX: 0
		property real velocityY: 0

		readonly property alias active: sensor.active
		property bool handlerLoop: false

		radius: KeyboardService.rounding
		color: "#292c30"

		border.color: "#292c30"
		border.width: 1

		states: [
			State {
				name: "ACTIVE"
				when: false
				PropertyChanges {root.border.color: "#e93a9a"}
				PropertyChanges {root.color: "#462e40"}
			}
		]
		transitions: [
			Transition {
				from: "ACTIVE"
				ColorAnimation { properties: "touchArea.border.color"; easing.type: Easing.OutQuad; duration: 100 }
				ColorAnimation { properties: "touchArea.color"; easing.type: Easing.OutQuad; duration: 100 }
			},
		]

	PointHandler {
		id: sensor
		acceptedDevices: PointerDevice.TouchScreen
		onActiveChanged: { if(active) {
			root.prevX = sensor.point.position.x
			root.prevY = sensor.point.position.y
			root.errorX = 0
			root.errorY = 0
			root.handlerLoop = true
		}
	} }
	Timer {
		interval: 7; running: root.handlerLoop; repeat: true
		onTriggered: {if(!gateronMelodic.running) {
			if(sensor.active){
				const velX = sensor.point.velocity.x
				const velY = sensor.point.velocity.y
				const velValue = Math.sqrt( Math.pow(velX, 2) + Math.pow(velY, 2) )
				root.velocityX = velValue > root.flickThreshold ? velX : 0
				root.velocityY = velValue > root.flickThreshold ? velY : 0

				const posX = sensor.point.position.x
				const posY = sensor.point.position.y

				if( 0 < posX && posX < root.boundX && 0 < posY && posY < root.boundY ) {
					const baseX = (posX - root.prevX) * root.dragFactor + root.errorX
					const baseY = (posY - root.prevY) * root.dragFactor + root.errorY

					const commandX = Math.round(baseX)
					root.errorX = baseX - commandX

					const commandY = Math.round(baseY)
					root.errorY = baseY - commandY

					const command = [ "ydotool", "mousemove", "-x", `${commandX}`, "-y", `${commandY}`]
					root.prevX = posX
					root.prevY = posY
					gateronMelodic.command = command
					gateronMelodic.running = true
				}
			} else {
				if(Math.sqrt( Math.pow(root.velocityX, 2) + Math.pow(velocityY, 2) ) > 2) {
					const baseX = root.velocityX * 0.007 * root.flickFactor + root.errorX
					const baseY = root.velocityY * 0.007 * root.flickFactor + root.errorY

					const commandX = Math.round(baseX)
					root.errorX = baseX - commandX

					const commandY = Math.round(baseY)
					root.errorY = baseY - commandY

					const command = [ "ydotool", "mousemove", "-x", `${commandX}`, "-y", `${commandY}`]
					gateronMelodic.command = command
					gateronMelodic.running = true

					root.velocityX = root.velocityX * root.flickDecel
					root.velocityY = root.velocityY * root.flickDecel
				} else {
					root.handlerLoop = false
				}
			}
		} }
	}
	Process {
		id: gateronMelodic
		running: false
	}
}
