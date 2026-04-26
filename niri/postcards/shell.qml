import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
// import "./items"
import "./services"
// import "./widgets"

PanelWindow {
	id: root
	// required property var modelData
	// screen: modelData

	color: "transparent"

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Background

	Repeater {
		id: repeater
		anchors.fill: parent
		model: WallpaperService.initialized ? WallpaperService.count : 0
		Image {
			id: component

			x: WallpaperService.images[modelData].x
			y: WallpaperService.images[modelData].y
			z: WallpaperService.images[modelData].z

			width: WallpaperService.size
			height: WallpaperService.size

			rotation: WallpaperService.images[modelData].rotation

			source: WallpaperService.images[modelData].url
			sourceSize.width: 2 * WallpaperService.size
			sourceSize.height: 2 * WallpaperService.size

			fillMode: Image.PreserveAspectFit
			asynchronous: true
			cache: false
			antialiasing: true
			mipmap: true

			opacity: 0
			onStatusChanged: if (component.status == Image.Ready) component.opacity = 1
			Behavior on opacity { NumberAnimation { duration: 1000 } }

			states: [
				State {
					name: "hide"
					when: WallpaperService.nextRemoval == modelData && WallpaperService.removalState == "hide"
					PropertyChanges {component.opacity: 0}
				},
				State {
					name: "update"
					when: WallpaperService.nextRemoval == modelData && WallpaperService.removalState == "update"
					PropertyChanges {component.opacity: 0}
					PropertyChanges {component.source: WallpaperService.images[modelData].url}
					PropertyChanges {component.x: WallpaperService.images[modelData].x}
					PropertyChanges {component.y: WallpaperService.images[modelData].y}
					PropertyChanges {component.z: WallpaperService.images[modelData].z}
					PropertyChanges {component.rotation: WallpaperService.images[modelData].rotation}
				},
				State {
					name: "reveal"
					when: WallpaperService.nextRemoval == modelData && WallpaperService.removalState == "reveal"
					PropertyChanges {component.opacity: 1}
				},
			]

			RectangularShadow {
				anchors.centerIn: parent
				width: parent.paintedWidth
				height: parent.paintedHeight
				z: -1
				color: "#88000000"
				blur: 10
				spread: 5
				radius: 0
			}
		}
	}
}
