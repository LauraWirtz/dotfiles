import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import "./items"
import "./services"
// import "./widgets"

ShellRoot {
	settings.watchFiles: false
	Variants {
		model: Quickshell.screens.filter(screen => {
			return screen.name == "DP-1" || screen.name == "HDMI-A-1"
		})
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

				size: 320
				maxRotation: 15

				exclusionZones: [
					{
						x: root.screen.width/2 - Math.min(root.screen.width - 20, 1260)/2,
						y: root.screen.height - 62,
						width: Math.min(root.screen.width - 20, 1260),
						height: 62
					}
				]

				// border: 20
				// borders.bottom: 56 + 2*10

				source: Quickshell.env("QS_SOURCE").replace(/'/g, "")
				count: Math.round(root.screen.width * root.screen.height / 200000)
			}

			Item {
				anchors.fill: parent
				layer.enabled: true

				Repeater {
					id: repeater
					anchors.fill: parent
					model: wallpaperService.images
					delegateModelAccess: DelegateModel.ReadWrite
					delegate: PostCard {}
				}
			}
		}
	}
}

