// ClockWidget.qml
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

MenuWithButton {
	icon.name: "list-add"
	icon.color: Material.color(Material.Blue, Material.Shade200)

	content: RowLayout {
		spacing: 16
		DesktopWidget {
			model: DesktopService.getFilteredEntries(true, [
				"firefox",
				"org.kde.dolphin",
				"org.kde.kate",
				"foot",
			])
			orientation: ListView.Vertical
			display: AbstractButton.IconOnly
			interactive: false
			size: 64
			spacing: 0
		}
		DesktopWidget {
			model: DesktopService.getFilteredEntries(true, [
				"net.kuribo64.melonDS",
				"org.azahar_emu.Azahar",
				"dolphin-emu",
				"dev.eden_emu.eden",
			])
			orientation: ListView.Vertical
			display: AbstractButton.IconOnly
			interactive: false
			size: 64
			spacing: 0
		}
		DesktopWidget {
			Layout.fillHeight: true
			model: DesktopService.getFilteredEntries(false, [
				"firefox",
				"org.kde.dolphin",
				"org.kde.kate",
				"foot",

				"net.kuribo64.melonDS",
				"org.azahar_emu.Azahar",
				"dolphin-emu",
				"dev.eden_emu.eden",
			])
			orientation: ListView.Vertical
			interactive: false
			spacing: 0
		}
	}

}
