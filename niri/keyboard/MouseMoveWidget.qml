// Bar.qml
import Quickshell
import Quickshell.Io
import QtQuick


Rectangle {
	id: root

	width: 6 * KeyboardService.scale - 2*KeyboardService.padding
	height: 4 * KeyboardService.scale - 2* KeyboardService.padding

	readonly property real boundX: root.width
	readonly property real boundY: root.height
	readonly property real dragFactor: 0.666

	readonly property real flickThreshold: 200
	readonly property real flickFactor: 0.666
	readonly property real flickDecel: 0.98


	property real prevX: 0
	property real prevY: 0
	property real errorX: 0
	property real errorY: 0
	property real velocityX: 0
	property real velocityY: 0

	readonly property alias active: sensor.active

	property bool isScrollMode: false

	readonly property real scrollDecel: 0.98
	readonly property int scrollInterval: 40

	property int scrollCountY: 0
	property real scrollSum: 0


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
			root.scrollCountY = Math.round(sensor.point.position.y / root.scrollInterval)
			moveFlickLoop.running = false
			scrollFlickLoop.running = false
			root.isScrollMode = root.prevX > 4 * KeyboardService.scale
		} else {
			root.prevX = 0
			root.prevY = 0
			root.errorX = 0
			root.errorY = 0
			root.scrollSum = 0
			root.scrollCountY = 0
			if(root.isScrollMode) {
				scrollFlickLoop.running = true
			} else {
				moveFlickLoop.running = true
			}
		} }
		onPointChanged: {
			if(sensor.active) {
				if(root.isScrollMode) {
					handleActiveScroll()
				} else {
					handleActiveMove()
				}
			}
		}
		function updateVelocity() {
			const velX = sensor.point.velocity.x
			const velY = sensor.point.velocity.y
			const velValue = Math.sqrt( Math.pow(velX, 2) + Math.pow(velY, 2) )
			root.velocityX = velValue > root.flickThreshold ? velX : 0
			root.velocityY = velValue > root.flickThreshold ? velY : 0
		}
		function handleActiveMove() {
			updateVelocity()

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
				runner.command = command
				runner.running = true
			}
		}
		function handleActiveScroll() {
			updateVelocity()

			const newCountY = Math.round(sensor.point.position.y / root.scrollInterval)

			var command = [ "ydotool", "mousemove", "-w", "-x", "0", "-y", `${newCountY - root.scrollCountY}` ]

			root.scrollCountY = newCountY

			scroller.command = command
			scroller.running = true
		}
	}
	Timer {
		id: moveFlickLoop
		interval: 7; running: false; repeat: true
		onTriggered: {if(!runner.running) {
			if(Math.sqrt( Math.pow(root.velocityX, 2) + Math.pow(root.velocityY, 2) ) > 2) {
				const baseX = root.velocityX * 0.007 * root.flickFactor + root.errorX
				const baseY = root.velocityY * 0.007 * root.flickFactor + root.errorY

				const commandX = Math.round(baseX)
				root.errorX = baseX - commandX

				const commandY = Math.round(baseY)
				root.errorY = baseY - commandY

				const command = [ "ydotool", "mousemove", "-x", `${commandX}`, "-y", `${commandY}`]
				runner.command = command
				runner.running = true

				root.velocityX = root.velocityX * root.flickDecel
				root.velocityY = root.velocityY * root.flickDecel
			} else {
				running = false
			}
		} }
	}
	Process {
		id: runner
		running: false
	}
	Timer {
		id: scrollFlickLoop
		interval: 7; running: false; repeat: true
		onTriggered: {if(!scroller.running) {
			if(Math.abs(root.velocityY) > 50) {
				root.scrollSum += root.velocityY * 0.007
				const newCountY = Math.round(root.scrollSum / root.scrollInterval)

				var command = [ "ydotool", "mousemove", "-w", "-x", "0", "-y", `${newCountY- root.scrollCountY}` ]

				root.scrollCountY = newCountY

				scroller.command = command
				scroller.running = true

				root.velocityY = root.velocityY * root.scrollDecel
			} else {
				scrollFlickLoop.running = false
			}
		} }
	}
	Process {
		id: scroller
		running: false
	}
}
