// ClockWidget.qml
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

Rectangle {
	id: root
	color: "#202326"
	radius: 16

	// Layout.preferredHeight: list.contentHeight
	implicitHeight: list.contentHeight
	Layout.fillWidth: true

	component DesktopEntryDelegate: Button {
		padding: 0

		font.pixelSize: 20
		font.weight: 300

		icon.name: model.icon
		icon.color: "transparent"
		icon.width: 32
		icon.height: 32
		flat: true

		text: customNames(model.name)

		onClicked: { Niri.spawn(model.command); Niri.closeOverview() }
	}

	function customNames(name): string {
		switch(name) {
			case "GNU Image Manipulation Program": return "GIMP";
			case "Fcitx 5 Configuration": return "Fcitx5 Config";
			case "TmForever": return "TmUnited";
			default: return name;
		}
	}

	GridView {
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: list

		anchors.fill: parent

		cellWidth: width / 3
		cellHeight: 56
		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		height: contentHeight
		interactive: false

		model: DesktopEntries.applications.values
		delegate: DesktopEntryDelegate {}
	}
}
