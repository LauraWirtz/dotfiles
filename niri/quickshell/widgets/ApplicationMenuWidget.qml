// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import "../items"
import "../services"
import "../widgets"

import QtQuick.Controls.Material

MenuWithButton {
	name: "apps"
	icon.name: "edit-find"
	color: Material.Green
	content: RowLayout {
		anchors.centerIn: parent
		Layout.fillWidth: true
		spacing: 16
		Loader {
			active: false
			sourceComponent: Component {
				DesktopWidget {
					model: [
						DesktopService.byId("net.kuribo64.melonDS"),
						DesktopService.byId("org.azahar_emu.Azahar"),
						DesktopService.byId("dolphin-emu"),
						DesktopService.byId("info.cemu.Cemu"),
						DesktopService.byId("Ryujinx"),
					]
					alignment: Qt.AlignHCenter
					display: AbstractButton.IconOnly
					interactive: false
					size: 64
					cellHeight: 88
				}
			}
			Timer {
				interval: 3000; running: true; repeat: false
				onTriggered: parent.active = true
			}
		}
		DesktopWidget {
			Layout.fillWidth: true
			Layout.fillHeight: true
			model: DesktopService.getFilteredEntries([
				"net.kuribo64.melonDS",
				"org.azahar_emu.Azahar",
				"dolphin-emu",
				"info.cemu.Cemu",
				"Ryujinx",
			])
			flow: GridView.FlowTopToBottom
			cellHeight: 54
		}
	}
}
