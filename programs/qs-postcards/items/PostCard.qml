import Quickshell
import QtQuick
import QtQuick.Effects
import "../services"

Item {
	id: root

	required property WallpaperService service
	required property int index
	required property string url
	required property real posX
	required property real posY
	required property real rot
	required property real w
	required property real h

	x: posX
	y: posY
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
		anchors.centerIn: parent
		width: image.paintedWidth + 4
		height: image.paintedHeight + 4
		color: "#88000000"
		blur: 10
		// spread: 5
		radius: 5
	}
	Rectangle {
		anchors.centerIn: parent

		width: image.paintedWidth
		height: image.paintedHeight
		color: "beige"
	}
	Image {
		id: image
		anchors.centerIn: parent

		sourceSize.width: 2 * wallpaperService.size
		sourceSize.height: 2 * wallpaperService.size

		width: wallpaperService.size
		height: wallpaperService.size

		fillMode: Image.PreserveAspectFit
		asynchronous: true
		cache: false
		mipmap: true

		onStatusChanged: {
			if(status == Image.Ready) { //calculate size + get new position once image loaded
				const aspect = Math.max(paintedWidth/paintedHeight, paintedHeight/paintedWidth)
				const areaFactor = Math.pow(aspect, 0.5)

				root.w = areaFactor * paintedWidth
				root.h = areaFactor * paintedHeight
				width = areaFactor * wallpaperService.size
				height = areaFactor  * wallpaperService.size

				root.service.positionPostcard(root.index)

				root.opacity = 1
			} else if (status == Image.Error) {
				root.service.handleMissingImage(root.index)
			}
		}
	}
	Rectangle {
		anchors.centerIn: parent

		width: image.paintedWidth + 4
		height: image.paintedHeight + 4

		radius: 5

		antialiasing: true

		color: "transparent"

		border.color: "beige"
		border.width: 4
	}
}
