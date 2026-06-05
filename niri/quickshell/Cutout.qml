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
	margins.bottom: 13 + 10

	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "qs-cutout"
	mask: Region { item: Item {} }

	implicitHeight: 26
	implicitWidth: 70

	Rectangle {
		Material.theme: Material.Dark
		Material.accent: Material.Blue
		id: overviewShape

		anchors.fill: parent
		radius: 13

		color: "black"
		opacity: 0.33
	}
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
