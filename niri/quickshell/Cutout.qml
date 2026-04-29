// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import "./items"
import "./services"
import "./widgets"

import QtQuick.Controls.Material

PanelWindow {
	id: root
	required property var modelData
	screen: modelData

	color: "transparent"

	anchors.bottom: true
	margins.bottom: 8

	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay

	implicitHeight: 26
	implicitWidth: 80

	MouseArea {
		id: mouseArea

		anchors.fill: parent

		acceptedButtons: Qt.LeftButton | Qt.BackButton | Qt.ForwardButton

		onClicked: event => {
			switch (event.button) {
				case Qt.BackButton:
					Niri.focusWorkspaceDown();
					break;
				case Qt.ForwardButton:
					Niri.focusWorkspaceUp();
					break;
				default:
					Niri.toggleOverview()
			}
		}
		onWheel: event => {
			if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
			else { Niri.focusColumnRight() }
		}

		Rectangle {
			Material.theme: Material.Dark
			Material.accent: Material.Blue
			id: overviewShape

			anchors.fill: parent
			radius: 13

			color: "black"

			Loader {
				anchors.centerIn: parent
				active: root.screen.name == "eDP-1"
				sourceComponent: BatteryWidget {}
			}
			Loader {
				anchors.centerIn: parent
				active: root.screen.name != "eDP-1"
				sourceComponent: ClockWidget {}
			}
		}
	}
}
