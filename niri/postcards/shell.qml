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

			Item {
				anchors.fill: parent
				layer.enabled: true

				Repeater {
					id: repeater
					anchors.fill: parent
					model: wallpaperService.images
					Image {
						id: component

						x: posX
						y: posY
						z: posZ

						width: wallpaperService.size
						height: wallpaperService.size

						rotation: rot

						source: url
						sourceSize.width: 2 * wallpaperService.size
						sourceSize.height: 2 * wallpaperService.size

						fillMode: Image.PreserveAspectFit
						asynchronous: true
						cache: false
						mipmap: true

						visible: component.status == Image.Ready


						Rectangle {
							anchors.centerIn: parent

							z: -2

							width: parent.paintedWidth
							height: parent.paintedHeight
							color: "beige"
						}

						RectangularShadow {
							anchors.centerIn: parent
							width: parent.paintedWidth + 4
							height: parent.paintedHeight + 4
							z: -1
							color: "#88000000"
							blur: 10
							// spread: 5
							radius: 0
						}
						Rectangle {
							anchors.centerIn: parent

							width: parent.paintedWidth + 4
							height: parent.paintedHeight + 4

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

