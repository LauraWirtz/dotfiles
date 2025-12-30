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

Item {
	id: root

	// Layout.preferredHeight: list.contentHeight
	implicitHeight: list.contentHeight
	Layout.fillWidth: true

	component DesktopEntryDelegate: RowLayout {


		Button {
			Layout.leftMargin: 16
			Layout.rightMargin: 16
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
	}

	function customNames(name): string {
		switch(name) {
			case "GNU Image Manipulation Program": return "GIMP";
			case "Fcitx 5 Configuration": return "Fcitx5 Config";
			case "TmForever": return "TmUnited";
			default: return name;
		}
	}

	ListView {
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: list

		anchors.fill: parent

		// cellWidth: width
		// cellHeight: 48
		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		height: contentHeight
		interactive: false

		model: DesktopEntries.applications.values
		delegate: DesktopEntryDelegate {}
		// cacheBuffer: 2*height
	}
}
