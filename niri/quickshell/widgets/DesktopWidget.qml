// ClockWidget.qml
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

Rectangle {
	id: root
	color: "#202326"
	radius: 8

	Layout.fillWidth: true
	Layout.preferredHeight: list.contentItem.childrenRect.height

	property string show: ""
	property var hide: []

	component DesktopEntryDelegate: Button {
		id: button
		padding: 0

		font.pixelSize: 20
		font.weight: 300

		icon.name: modelData.icon
		icon.color: "transparent"
		icon.width: 32
		icon.height: 32
		flat: true

		text: customNames(modelData.name)

		onClicked: { Niri.spawn(modelData.command); Niri.closeOverview() }
	}

	function searchCategories(categories, term): bool {
		for(var entry in categories) {
			if(categories[entry] == term) return true
		}
		return false
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
		// clip: true

		cellWidth: width / 3
		cellHeight: 56
		// contentWidth: width
		// contentHeight: contentItem.childrenRect.height
		// height: contentHeight
		interactive: false

		model: DesktopService.sortedEntries
		delegate: DesktopEntryDelegate {}
	}
}
