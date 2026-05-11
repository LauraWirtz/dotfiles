// import Quickshell
import QtQuick
import QtQuick.Controls
// import QtQuick.Layouts
import "../services"
// import "../widgets"
// import "../items"

import QtQuick.Controls.Material


Repeater {
	id: list

	required property string screen

	model: Niri.getWindowsByScreen(screen)

	delegate: Button {
		Material.theme: Material.Dark
		Material.accent: Material.Green
		Material.roundedScale: Material.NotRounded
		id: button
		icon.name: DesktopService.customIcons(modelData.app_id)
		icon.color: "transparent"
		icon.width: 40
		icon.height: 40
		flat: true
		// text: modelData.title
		// width: 256
		// margin: 0
		// radius: 0

		Component.onCompleted: {
			button.highlighted = modelData.id == Niri.getActiveWindowIdByScreen(screen)
		}

		onClicked: Niri.focusWindow(modelData.id)
	}
}
