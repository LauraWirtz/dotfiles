// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "./services"
import "./widgets"
import "./items"

PanelWindow {
	id: root
	color: "transparent"

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Top

	mask: Region { item: bar }

	Rectangle {
		id: bar

		anchors.horizontalCenter: parent.horizontalCenter
		y: 1 * parent.height + 10

		implicitWidth: children[0].implicitWidth
		implicitHeight: children[0].implicitHeight

		radius: 5

		color: "#292c30"

		states: State {
			name: "OVERVIEW"
			when: (Niri.inOverview)
			PropertyChanges {bar.y: 0.75 * root.height - 0.5 * bar.height}
		}

		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 250 }
		}

		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top

			IconButton {
				source: "/home/laura/.local/share/icons/Breeze-dark/actions/24@2x/window-new.svg"
				icon_width: 48
				icon_height: 48

				topPadding: 8
				bottomPadding: 8
				leftPadding: 8
				rightPadding: 8

				onTapped: Niri.spawn([ "nwg-drawer" ])
			}

			IconButton {
				source: "/home/laura/.local/share/icons/Breeze-dark/actions/24@2x/view-fullscreen.svg"
				icon_width: 48
				icon_height: 48

				topPadding: 8
				bottomPadding: 8
				leftPadding: 8
				rightPadding: 8

				onTapped: Niri.fullscreenWindow()
			}

			IconButton {
				source: "/home/laura/.local/share/icons/Breeze-dark/actions/24@2x/view-split-left-right.svg"
				icon_width: 48
				icon_height: 48

				topPadding: 8
				bottomPadding: 8
				leftPadding: 8
				rightPadding: 8

				onTapped: Niri.switchPresetColumnWidth()
			}

			IconButton {
				source: "/home/laura/.local/share/icons/Breeze-dark/actions/24@2x/application-exit.svg"
				icon_width: 48
				icon_height: 48

				topPadding: 8
				bottomPadding: 8
				leftPadding: 8
				rightPadding: 8

				onTapped: Niri.closeWindow()
			}

			BrightnessWidget {}

			VolumeWidget {}
		}

		RectangularShadow {
			anchors.fill: bar
			z: -1
			blur: 15
			spread: 0
			radius: 5
		}
	}
}
