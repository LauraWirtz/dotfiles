
import QtQuick

Item {
	id: root
	anchors.fill: parent

	function onUp() {}
	function onDown() {}
	function onLeft() {}
	function onRight() {}

	property alias grabPermissions: dragHandler.grabPermissions

	states: [
		State {
			name: "STANDBY"
			when: !dragHandler.active
			StateChangeScript { script: dragHandler.enabled = true; }
		},
		State {
			name: "UP"
			when: dragHandler.centroid.velocity.y < -1000
			StateChangeScript { script: { onUp(); dragHandler.enabled = false; } }
		},
		State {
			name: "DOWN"
			when: dragHandler.centroid.velocity.y > 1000
			StateChangeScript { script: { onDown(); dragHandler.enabled = false; } }
		},
		State {
			name: "LEFT"
			when: dragHandler.centroid.velocity.x < -1000
			StateChangeScript { script: { onLeft(); dragHandler.enabled = false; } }
		},
		State {
			name: "RIGHT"
			when: dragHandler.centroid.velocity.x > 1000
			StateChangeScript { script: { onRight(); dragHandler.enabled = false; } }
		},
	]
	DragHandler {
		id: dragHandler
		acceptedDevices: PointerDevice.TouchScreen
	}
}
