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
	Material.theme: Material.Dark
	Material.accent: Material.Green

	Layout.leftMargin: 6
	implicitWidth: contentItem.childrenRect.width
	implicitHeight: 52

	orientation: ListView.Horizontal

	required property string screen

	model: Niri.getWindowsByScreen(screen)

	delegate: MenuWithButton {
		id: button
		icon.name: DesktopService.customIcons(modelData.app_id)
		icon.color: "transparent"
		// text: modelData.is_focused ? modelData.title : ""
		flat:true
		radius: 26


		content: WindowActionWidget { windowModelData: modelData }
		callback: () => {
			if(modelData.is_focused || Niri.inOverview) {
				return false
			} else {
				Niri.focusWindow(modelData.id)
				return true
			}
		}

		states: [
			State {
				name: "focused"
				when: modelData.is_focused
				PropertyChanges {button.width: 256}
				PropertyChanges {button.text: modelData.title}
				PropertyChanges {button.highlighted: true}

			},
		]
	}
}
