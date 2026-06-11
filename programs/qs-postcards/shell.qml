import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
// import "./items"
import "./services"
// import "./widgets"

ShellRoot {
	settings.watchFiles: false
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

				border: 20
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

						required property real posX
						required property real posY
						required property real rot
						required property string url

						x: posX
						y: posY
						rotation: rot

						opacity: 0

						Behavior on opacity {
							NumberAnimation { duration: 1000; easing: Easing.OutQuad }
						}

						onUrlChanged: {
							if(url != "") {
								image.source = url
							} else {
								opacity = 0
							}
						}

						RectangularShadow {
							anchors.centerIn: parent
							width: image.paintedWidth + 4
							height: image.paintedHeight + 4
							color: "#88000000"
							blur: 10
							// spread: 5
							radius: 6
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

							sourceSize.width: 4 * wallpaperService.size
							sourceSize.height: 4 * wallpaperService.size

							fillMode: Image.PreserveAspectFit
							asynchronous: true
							cache: false
							mipmap: true

							onStatusChanged: {
								if(status == Image.Ready) {
									const volFactor = Math.pow(Math.max(paintedWidth/paintedHeight, paintedHeight/paintedWidth), 0.5)
									width = volFactor * wallpaperService.size
									height = volFactor  * wallpaperService.size
									component.opacity = 1
								}
							}
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

