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
	flat: true

	onClicked: {
		if(!callback()) {
			button.active = !button.active
		}

	}

	property var callback: () => {return false}
	property alias content: rectangle.data
	property real margin: 16
	property alias menuRadius: background.radius

	property bool active: false

	hoverEnabled: true
	onHoveredChanged: {
		exitTimer.running = !hovered
	}

	Item {
		id: anchor
		anchors.verticalCenter: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
	}

	PopupWindow {
		id: menu

		anchor.item: button
		anchor.gravity: Edges.Top
		anchor.margins.top: 11
		anchor.margins.left: button.width / 2

		mask: Region { item: mouseArea }

		implicitWidth: rectangle.implicitWidth + 20 + 2*button.margin
		implicitHeight: rectangle.implicitHeight + 20 + 2*button.margin

		visible: button.active
		color: "transparent"

		RectangularShadow {
			anchors.fill: mouseArea
			color: "#88000000"
			blur: 5
			spread: 5
			radius: background.radius
		}
		Rectangle {
			id: background
			anchors.centerIn: parent
			implicitWidth: rectangle.implicitWidth + 2*button.margin
			implicitHeight: rectangle.implicitHeight + 2*button.margin

			radius: 8
			color: "#292c30"
		}
		MouseArea {
			id: mouseArea
			anchors.fill: parent
			anchors.margins: 10
			hoverEnabled: true
			onEntered: exitTimer.running = false
			onExited: exitTimer.running = true
			Item {
				id: rectangle
				anchors.fill: parent
				anchors.margins: button.margin
				implicitWidth: children[0].implicitWidth
				implicitHeight: children[0].implicitHeight

			}
		}
	}
	Timer {
		id: exitTimer
		interval: 125; running: false; repeat: false
		onTriggered: button.active = false
	}
}
