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
	icon.width: 32
	icon.height: 32
	radius: 8
	flat: true

	onClicked: PopupService.currentPopup = PopupService.currentPopup == button.name ? "" : button.name

	property alias content: rectangle.data
	required property string name

	states: [
		State {
			name: "ACTIVE"
			when: PopupService.currentPopup == button.name
			PropertyChanges {button.checked: true}
			PropertyChanges {menu.visible: true}
			PropertyChanges {button.down: true }
		},
	]

	Item {
		id: anchor
		anchors.horizontalCenter: parent.horizontalCenter
	}

	PopupWindow {
		id: menu
		anchor.item: anchor
		anchor.gravity: Edges.Top | Edges.Right
		anchor.margins.top: 24
		anchor.margins.left: -0.5 * rectangle.implicitWidth - 40
		mask: Region { item: rectangle }
		implicitWidth: rectangle.implicitWidth + 80
		implicitHeight: rectangle.implicitHeight + 80
		visible: false
		color: "transparent"

		Rectangle {
			id: rectangle
			anchors.centerIn: parent
			implicitWidth: children[0].implicitWidth + 32
			implicitHeight: children[0].implicitHeight + 32

			radius: 8
			color: "#292c30"
		}
		RectangularShadow {
			anchors.fill: rectangle
			z: -1
			blur: 30
			spread: 0
			radius: 8
			offset.x: 5
			offset.y: 5
		}
	}
}
