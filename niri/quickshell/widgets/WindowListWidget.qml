// Bar.qml
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../services"

import QtQuick.Controls.Material


ListView {
	Material.theme: Material.Dark
	Material.accent: Material.Green
	Layout.leftMargin: 6
	implicitWidth: contentItem.childrenRect.width
	implicitHeight: contentItem.childrenRect.height
	orientation: ListView.Horizontal
	model: Niri.getWindowsByScreen(root.screen.name)
	delegate: Button {
		id: button
		// width: 200
		icon.name: DesktopService.customIcons(modelData.app_id)
		icon.color: "transparent"
		// text: modelData.is_focused ? modelData.title : ""
		// highlighted: modelData.is_focused
		onClicked: Niri.focusWindow(modelData.id)
		flat:true

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
