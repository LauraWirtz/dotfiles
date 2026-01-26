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

Button {
	id: button

	icon.name: ""
	icon.width: 32
	icon.height: 32

	flat: true
	checkable: true

	checked: menu.visible
	onClicked: PopupService.currentPopup = PopupService.currentPopup == button.name ? "" : button.name

	property alias content: rectangle.data
	required property string name

	states: [
		State {
			name: "ACTIVE"
			when: PopupService.currentPopup == button.name
			PropertyChanges {button.checked: true}
			PropertyChanges {menu.visible: true}
		},
	]

	PopupWindow {
		id: menu
		anchor.item: button
		anchor.gravity: Edges.Top | Edges.Right
		anchor.margins.left: -16
		width: contentItem.children[0].implicitWidth + 32
		height: contentItem.children[0].implicitHeight + 32
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
			blur: 15
			spread: 0
			radius: 8
		}
	}
}
