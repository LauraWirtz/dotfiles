import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
// import "./items"
import "./services"
// import "./widgets"

Scope {
	Variants {
		model: Quickshell.screens
		PanelWindow {
			id: root
			required property var modelData
			screen: modelData

			color: "transparent"

			anchors {
				top: true
				bottom: true
				left: true
				right: true
			}
			exclusionMode: ExclusionMode.Ignore
			WlrLayershell.layer: WlrLayer.Background

			WallpaperService {
				id: wallpaperService

				monitorWidth: root.screen.width
				monitorHeight: root.screen.height

				border: -100

				source: "/home/laura/Pictures/アニメ/"
				count: Math.round(root.screen.width * root.screen.height / 200000)
			}

			Repeater {
				id: repeater
				anchors.fill: parent
				model: wallpaperService.initialized ? wallpaperService.count : 0
				Image {
					id: component

					x: wallpaperService.images[modelData].x
					y: wallpaperService.images[modelData].y
					z: wallpaperService.images[modelData].z

					width: wallpaperService.size
					height: wallpaperService.size

					rotation: wallpaperService.images[modelData].rotation

					source: wallpaperService.images[modelData].url
					sourceSize.width: 2 * wallpaperService.size
					sourceSize.height: 2 * wallpaperService.size

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
							when: wallpaperService.nextRemoval == modelData && wallpaperService.removalState == "hide"
							PropertyChanges {component.opacity: 0}
						},
						State {
							name: "update"
							when: wallpaperService.nextRemoval == modelData && wallpaperService.removalState == "update"
							PropertyChanges {component.opacity: 0}
							PropertyChanges {component.source: wallpaperService.images[modelData].url}
							PropertyChanges {component.x: wallpaperService.images[modelData].x}
							PropertyChanges {component.y: wallpaperService.images[modelData].y}
							PropertyChanges {component.z: wallpaperService.images[modelData].z}
							PropertyChanges {component.rotation: wallpaperService.images[modelData].rotation}
						},
						State {
							name: "reveal"
							when: wallpaperService.nextRemoval == modelData && wallpaperService.removalState == "reveal"
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
	}
}

