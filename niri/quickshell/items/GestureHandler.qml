
import QtQuick

Item {
	id: root
	anchors.fill: parent

	function onTapped() {}
	function onClicked() {}

	function onUp() {}
	function onDown() {}
	function onLeft() {}
	function onRight() {}

	states: [
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

	TapHandler {
		id: mouseHandler
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad | PointerDevice.Stylus
		gesturePolicy: TapHandler.ReleaseWithinBounds
		onTapped: root.onClicked()
	}
	TapHandler {
		id: tapHandler
		acceptedDevices: PointerDevice.TouchScreen
		gesturePolicy: TapHandler.ReleaseWithinBounds
		onTapped: root.onTapped()
	}
	DragHandler {
		id: dragHandler
		enabled: true
		onActiveChanged: enabled = active ? enabled : true
	}
}
