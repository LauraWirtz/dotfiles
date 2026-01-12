// Bar.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

import QtQuick.Controls.Basic

Rectangle {
	id: root

	width: 1 * KeyboardService.scale - 2*KeyboardService.padding
	height: 1 * KeyboardService.scale - 2* KeyboardService.padding

	readonly property int dragInterval: 12

	property int countX: 0

	readonly property alias active: sensor.active
	property bool handlerLoop: false

	radius: KeyboardService.rounding
	color: "#292c30"

	border.color: "#292c30"
	border.width: 1

	states: [
		State {
			name: "ACTIVE"
			when: sensor.active
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

	RoundButton {
		anchors.centerIn: parent
		icon.name: "transform-move-horizontal-symbolic"
		icon.width: 32
		icon.height: 32
		icon.color: "white"
		flat:true
		enabled: false
	}

	PointHandler {
		id: sensor
		acceptedDevices: PointerDevice.TouchScreen
		onActiveChanged: { if(active) {
			root.countX = Math.round(sensor.point.position.x / root.dragInterval)
			root.handlerLoop = true
		} else { root.handlerLoop = false}
	} }
	Timer {
		interval: 7; running: root.handlerLoop; repeat: true
		onTriggered: {if(!runner.running) {
			const newCountX = Math.round(sensor.point.position.x / root.dragInterval)

			var command = [ "ydotool", "key", "-d", "1" ]

			for(var i = newCountX; i < root.countX; i++) {
				 command = command.concat( [ "105:1", "105:0" ] )
			}
			for(var i = root.countX; i < newCountX; i++) {
				command = command.concat( [ "106:1", "106:0" ] )
			}

			root.countX = newCountX

			runner.command = command
			runner.running = command.length > 4
		} }
	}
	Process {
		id: runner
		running: false
	}
}
