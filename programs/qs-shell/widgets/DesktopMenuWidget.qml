// ClockWidget.qml
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

MenuWithButton {
	id: root
	icon.name: "list-add"
	icon.color: Material.color(Material.Blue, Material.Shade200)
	window.implicitHeight: 800

	content: RowLayout {
		spacing: 16
		Repeater {
			model: DesktopService.configuredEntries
			delegate: DesktopWidget {
				height: root.availablePopupHeight
				model: modelData.ids
				orientation: ListView.Vertical
				interactive: true

				spacing: 0
				size: modelData.layout.size
				showText: modelData.layout.showText
				showSections: modelData.layout.showSections
			}
		}
	}
}
