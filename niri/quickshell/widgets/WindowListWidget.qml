// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"
import "../widgets"
import "../items"

import QtQuick.Controls.Material


ListView {
	id: list
	Material.theme: Material.Dark
	Material.accent: Material.Green

	implicitWidth: contentItem.childrenRect.width
	implicitHeight: Math.max(52, contentItem.childrenRect.height)

	orientation: ListView.Horizontal
	clip: true

	required property string screen

	model: Niri.getWindowsByScreen(screen)
	currentIndex: Niri.getActiveWindowIndexByScreen(screen)

	highlightFollowsCurrentItem: false
	highlight: Rectangle {
		x: list.currentItem.x + list.currentItem.leftInset
		width: list.currentItem.width - list.currentItem.horizontalPadding
		height: list.currentItem.height

		opacity: 0.5
		color: Material.color(Material.Green, Material.Shade200)
	}

	delegate: MenuWithButton {
		id: button
		icon.name: DesktopService.customIcons(modelData.app_id)
		icon.color: "transparent"
		icon.width: 40
		icon.height: 40
		// text: modelData.title
		// width: 256
		margin: 0
		radius: 0


		content: WindowActionWidget { windowModelData: modelData }
		callback: () => {
			if(modelData.is_focused || Niri.inOverview) {
				return false
			} else {
				Niri.focusWindow(modelData.id)
				return true
			}
		}
	}
}
