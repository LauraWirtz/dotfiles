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

		onClicked: Niri.focusWindow(modelData.id)

		Component.onCompleted: {
			const active = modelData.id == Niri.getActiveWindowIdByScreen(screen)
			if(active) {
				button.highlighted = true
				handler.xAxis.enabled = true
				// handler.xAxis.minimum = (modelData.layout.pos_in_scrolling_layout[0] - 1.5) * button.width * -1
			}
		}

		DragHandler {
			id: handler
			xAxis.enabled: false
			yAxis.enabled: false
			onActiveChanged: {
				if(active) {
					button.z = 10
				} else {
					const movement = Math.sign(persistentTranslation.x) * Math.round(Math.abs(persistentTranslation.x / button.width) - 0.5)
					const oldPos = modelData.layout.pos_in_scrolling_layout[0]
					handler.enabled = false
					Niri.moveColumnToIndex(oldPos + movement)
				}
			}
		}
	}
}
