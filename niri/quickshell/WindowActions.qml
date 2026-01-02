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

import QtQuick.Controls.Material

PanelWindow {
	id: root
	color: "transparent"

	property var buttonsModel: [
		{ icon: "window-minimize-pip", command: ()=>Niri.toggleWindowFloating() },
		{ icon: "view-fullscreen", command: ()=>Niri.fullscreenWindow() },
		{ icon: "view-file-columns", command: ()=>Niri.centerColumn() },
		{ icon: "view-split-left-right", command: ()=>Niri.switchPresetColumnWidth() },
		{ icon: "application-exit", command: ()=>Niri.closeWindow() },
	]

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
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		anchors.horizontalCenter: parent.horizontalCenter
		y: 1 * parent.height + 10

		implicitWidth: children[0].implicitWidth
		implicitHeight: children[0].implicitHeight

		radius: 8

		color: "#292c30"

		states: State {
			name: "OVERVIEW"
			when: (Niri.inOverview)
			PropertyChanges {bar.y: 0.75 * root.height - 0.5 * bar.height}
		}

		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 150 }
		}

		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top

			Repeater {
				model: buttonsModel
				MenuBarItem {
					id: delegate
					icon.name: modelData.icon
					icon.color: "transparent"
					icon.width: 48
					icon.height: 48

					horizontalPadding: 12
					verticalPadding: 8

					onClicked: modelData.command()
				}
			}
		}

		RectangularShadow {
			anchors.fill: bar
			z: -1
			blur: 15
			spread: 0
			radius: 8
			cached: true
		}
	}
}
