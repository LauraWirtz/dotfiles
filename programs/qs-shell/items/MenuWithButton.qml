// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import "../items"
import "../services"
import "../widgets"

import QtQuick.Controls.Material

BreezeButton {
	id: button

	icon.name: ""
	icon.width: 24
	icon.height: 24

	onClicked: {
		const point = QsWindow.mapFromItem(this, 0, 0)
		let x = (QsWindow.window.screen.width - QsWindow.window.implicitWidth)/2 + point.x + implicitWidth/2 - popup.implicitWidth/2
		x = x + popup.implicitWidth <= QsWindow.window.screen.width ? x : QsWindow.window.screen.width - popup.implicitWidth
		x = x > 0 ? x : 0
		popup.margins.left = x
		popup.screen = QsWindow.window.screen

		if(!callback()) {
			button.active = !button.active
		}

	}

	property var callback: () => {return false}
	property alias content: rectangle.data
	property real margin: 16
	property alias menuRadius: background.radius

	property bool active: false
	highlighted: active

	hoverEnabled: true
	onHoveredChanged: {
		exitTimer.running = !hovered
	}

	Timer {
		id: exitTimer
		interval: 125; running: false; repeat: false
		onTriggered: button.active = false
	}

	PanelWindow {
		id: popup

		anchors.left: true
		anchors.bottom: true
		margins.bottom: 62

		color: "transparent"

		exclusionMode: ExclusionMode.Ignore
		WlrLayershell.namespace: "qs-taskbar-popup"

		visible: button.active

		implicitWidth: rectangle.implicitWidth + 2*button.margin
		implicitHeight: rectangle.implicitHeight  + 2*button.margin

		Rectangle {
			id: background
			anchors.fill: parent

			opacity: 0.85
			color: "#292c30"
			radius: 5

			MouseArea {
				id: mouseArea
				anchors.fill: parent
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
	}
}
