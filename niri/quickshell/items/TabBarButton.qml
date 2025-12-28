import QtQuick

Rectangle {
	id:root

	property bool show

	property alias source: image.source

	property alias icon_width: image.width
	property alias icon_height: image.height
	property real topPadding: 8
	property real bottomPadding: 8
	property real leftPadding: 16
	property real rightPadding: 16

	signal tapped

	implicitWidth: image.width + leftPadding + rightPadding
	height: image.height + topPadding + bottomPadding

	topLeftRadius: 5
	topRightRadius: 5

	color: "transparent"

	states: [
		State {
			name: "ENABLED"
			when: (root.show)
			PropertyChanges { root.color: "#202326" }
		}
	]

	transitions: Transition {
		ColorAnimation { properties: "root.color"; easing.type: Easing.InOutQuad; duration: 150 }
	}



	Image {
		id: image
		x: leftPadding
		y: topPadding
		width: 32
		height: 32
	}

	TapHandler {
		id: handler
		gesturePolicy: TapHandler.ReleaseWithinBounds
		onTapped: root.tapped()
	}
}
