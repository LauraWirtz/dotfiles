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

RoundButton {
	id: button

	icon.name: ""
	icon.width: 24
	icon.height: 24
	onClicked: PopupService.currentPopup = PopupService.currentPopup == button.name ? "" : button.name

	property alias content: rectangle.data
	required property string name
	property var color: Material.Green

	states: [
		State {
			name: "ACTIVE"
			when: PopupService.currentPopup == button.name
			// PropertyChanges {button.checked: true}
			PropertyChanges {menu.visible: true}
			// PropertyChanges {button.Material.foreground: "#292c30" }
			// PropertyChanges {button.Material.background: button.color }
		},
		State {
			name: "INACTIVE"
			when: PopupService.currentPopup != button.name
			// PropertyChanges {button.Material.foreground: button.color }
		},
	]

	Item {
		id: anchor
		anchors.centerIn: parent
	}

	PopupWindow {
		id: menu
		anchor.item: anchor
		anchor.gravity: Edges.Top | Edges.Right
		anchor.margins.top: 20
		anchor.margins.left: -20
		mask: Region { item: rectangle }
		implicitWidth: rectangle.implicitWidth + 40
		implicitHeight: rectangle.implicitHeight + 40
		visible: false
		color: "transparent"

		RectangularShadow {
			anchors.fill: rectangle
			blur: 20
			spread: 0
			radius: 20
			offset.x: 0
			offset.y: 0
		}
		Rectangle {
			id: rectangle
			anchors.centerIn: parent
			implicitWidth: children[0].implicitWidth + 32
			implicitHeight: children[0].implicitHeight + 32

			radius: 20
			color: "#292c30"
			gradient: Gradient {
				GradientStop { position: 0.0; color: Qt.lighter("#292c30", 1.2) }
				// GradientStop { position: 0.475; color: Qt.lighter("#292c30", 1 + 0.15*overviewShape.shading) }
				// GradientStop { position: 0.525; color: Qt.darker("#292c30", 1 + 0.15*overviewShape.shading) }
				GradientStop { position: 1.0; color: Qt.darker("#292c30", 1.2) }
			}
		}
		RoundButton {
			id: closeButton
			Material.theme: Material.Dark
			anchors.verticalCenter: rectangle.bottom
			anchors.horizontalCenter: rectangle.left

			icon.name: button.icon.name
			icon.width: 24
			icon.height: 24
			Material.foreground: "#292c30"
			Material.background: button.color

			onClicked: PopupService.currentPopup = ""
		}
	}
}
