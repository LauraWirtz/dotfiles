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

				border: 0
				borders.bottom: 56 + 2*10

				source: "/home/laura/Pictures/アニメ/"
				count: Math.round(root.screen.width * root.screen.height / 200000)
			}

			Item {
				anchors.fill: parent
				layer.enabled: true

				Repeater {
					id: repeater
					anchors.fill: parent
					model: wallpaperService.images
					Item {
						id: component

						x: posX
						y: posY
						z: posZ
						rotation: rot

						visible: image.status == Image.Ready

						RectangularShadow {
							anchors.centerIn: parent
							width: image.paintedWidth + 4
							height: image.paintedHeight + 4
							color: "#88000000"
							blur: 10
							// spread: 5
							radius: 0
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

							width: wallpaperService.size
							height: wallpaperService.size


							source: url
							sourceSize.width: 2 * wallpaperService.size
							sourceSize.height: 2 * wallpaperService.size

							fillMode: Image.PreserveAspectFit
							asynchronous: true
							cache: false
							mipmap: true
						}
						Rectangle {
							anchors.centerIn: parent

							width: image.paintedWidth + 4
							height: image.paintedHeight + 4

							radius: 6

							antialiasing: true

							color: "transparent"

							border.color: "beige"
							border.width: 4
						}
					}
				}
			}
		}
	}
}

