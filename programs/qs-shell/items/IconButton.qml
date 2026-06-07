import QtQuick

Item {
	id:root

	property alias source: image.source

	property alias icon_width: image.width
	property alias icon_height: image.height
	property real topPadding: 0
	property real bottomPadding: 0
	property real leftPadding: 0
	property real rightPadding: 0

	signal tapped

	width: image.width + leftPadding + rightPadding
	height: image.height + topPadding + bottomPadding


	Image {
		id: image
		x: leftPadding
		y: topPadding
		width: 24
		height: 24
	}

	TapHandler {
		id: handler
		gesturePolicy: TapHandler.ReleaseWithinBounds
		onTapped: root.tapped()
	}
}
