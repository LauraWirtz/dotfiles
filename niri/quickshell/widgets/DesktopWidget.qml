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

	Layout.preferredHeight: list.contentHeight
	implicitHeight: list.contentHeight
	Layout.fillWidth: true

	component DesktopEntryDelegate: RowLayout {


		Button {
			// Layout.fillWidth: true
			Layout.leftMargin: 16
			Layout.rightMargin: 16

			// width: list.width

			font.pixelSize: 20
			font.weight: 300

			icon.name: model.icon
			icon.color: "transparent"
			icon.width: 48
			icon.height: 48
			flat: true

			text: model.name

			TapHandler {
				gesturePolicy: TapHandler.ReleaseWithinBounds
				onTapped: { Niri.spawn(model.command); Niri.closeOverview() }
			}
		}
	}

	ListView {
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: list

		anchors.fill: parent

		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		clip: true

		model: DesktopEntries.applications.values
		delegate: DesktopEntryDelegate {}
		// cacheBuffer: 2*height
	}
}
