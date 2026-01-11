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

	width: 3 * KeyboardService.scale + 2*KeyboardService.padding
	height: 3 * KeyboardService.scale + 2* KeyboardService.padding

	radius: KeyboardService.rounding + 2*KeyboardService.padding
	color: "#202326"

	readonly property alias active: sensor.active
	property bool handlerLoop: false

	readonly property real bounds: root.width

	readonly property real flickThreshold: 200
	readonly property real flickFactor: 2
	readonly property real flickDecel: 0.98

	property real prevX: 0
	property real prevY: 0
	property real errorX: 0
	property real errorY: 0
	property real velocityX: 0
	property real velocityY: 0

	Rectangle {
		id: relative
		anchors.fill: parent
		anchors.margins: 2 * KeyboardService.padding

		radius: width / 2
		color: "#292c30"

		border.color: "#292c30"
		border.width: 1

		states: [
			State {
				name: "ACTIVE"
				when: sensor.active
				PropertyChanges {relative.border.color: "#e93a9a"}
				PropertyChanges {relative.color: "#462e40"}
			}
		]
		transitions: [
			Transition {
				from: "ACTIVE"
				ColorAnimation { properties: "key.border.color"; easing.type: Easing.OutQuad; duration: 100 }
				ColorAnimation { properties: "key.color"; easing.type: Easing.OutQuad; duration: 100 }
			},
		]
	}
	PointHandler {
		id: sensor
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
				const relX = posX - root.bounds / 2
				const relY = posY - root.bounds / 2
				const value = Math.sqrt( Math.pow(relX, 2) + Math.pow(relY, 2) )

				if( value < root.bounds / 2) {
					if( root.isRelInput ) {
						root.isRelInput = false
						root.prevX = sensor.point.position.x
						root.prevY = sensor.point.position.y
					}
					const baseX = posX + root.errorX - root.prevX
					const baseY = posY + root.errorY - root.prevY

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

	RectangularShadow {
		id: shadow
		anchors.fill: parent
		z: -1
		blur: 15
		spread: 0
		radius: parent.radius
	}
}
