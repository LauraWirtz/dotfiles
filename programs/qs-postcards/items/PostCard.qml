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
		color: "#88000000"
		blur: 10
		radius: root.service.frameWidth
	}
	Rectangle {
		anchors.fill: parent

		radius: root.service.frameWidth

		antialiasing: true

		color: root.service.frameColor
	}
	Image {
		id: image
		anchors.fill: parent
		anchors.margins: root.service.frameWidth

		sourceSize.width: 2 * root.service.size
		sourceSize.height: 2 * root.service.size

		fillMode: Image.PreserveAspectFit
		asynchronous: true
		cache: false
		mipmap: true
		antialiasing: true

		onStatusChanged: {
			if(status == Image.Ready) { //get new position once image loaded
				root.service.positionPostcard(root.index, paintedWidth, paintedHeight)
				root.opacity = 1
			} else if (status == Image.Error) { //notify service on missing Image
				root.service.handleMissingImage(root.index)
			}
		}
	}
}
