import Quickshell
import QtQuick
import QtQuick.Effects
import "../services"

Item {
	id: root

	required property WallpaperService service
	required property int index
	required property string url
	required property real rectX
	required property real rectY
	required property real rectWidth
	required property real rectHeight
	required property real rot

	x: rectX
	y: rectY
	width: rectWidth
	height: rectHeight
	rotation: rot

	opacity: 0

	Behavior on opacity {
		NumberAnimation { duration: 1000; easing: Easing.OutQuad }
	}

	onOpacityChanged: {
		if(opacity == 0) {
			// position = Qt.point(0, 0)
			image.source = url //update image once fully hidden
		}
	}

	onUrlChanged: {
		opacity = 0 //hide postcard when receiving new image
	}

	Component.onCompleted: {
		image.source = url
	}

	RectangularShadow {
		anchors.fill: parent
		anchors.margins: -2
		color: "#88000000"
		blur: 10
		// spread: 5
		radius: 5
	}
	Rectangle {
		anchors.fill: parent

		width: image.paintedWidth
		height: image.paintedHeight
		color: "beige"
	}
	Image {
		id: image
		anchors.fill: parent

		sourceSize.width: 2 * root.service.size
		sourceSize.height: 2 * root.service.size

		fillMode: Image.PreserveAspectFit
		asynchronous: true
		cache: false
		mipmap: true

		onStatusChanged: {
			if(status == Image.Ready) { //calculate size + get new position once image loaded
				const areaFactor = Math.pow(paintedWidth/paintedHeight, 0.5)

				root.rectWidth = root.service.size * areaFactor
				root.rectHeight = root.service.size / areaFactor

				root.service.positionPostcard(root.index)

				root.opacity = 1
			} else if (status == Image.Error) {
				root.service.handleMissingImage(root.index)
			}
		}
	}
	Rectangle {
		anchors.fill: parent
		anchors.margins: -2

		radius: 5

		antialiasing: true

		color: "transparent"

		border.color: "beige"
		border.width: 4
	}
}
