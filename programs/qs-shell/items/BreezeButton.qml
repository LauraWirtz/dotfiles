// Bar.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Controls.Basic

Button {
	id: root

	property bool square: true

	implicitWidth: square ? implicitHeight : Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)

	topInset: 5
	leftInset: 5
	rightInset: 5
	bottomInset: 5

	leftPadding: 12
	rightPadding: 12
	topPadding: 12
	bottomPadding: 12

	palette {
		accent: "#A5D6A7"
		buttonText: enabled ? "white" : "gray"
		// button: "lavender"
	}

	background: Item {
		Rectangle {
			anchors.fill: parent
			id: background
			// color: "#A5D6A7"
			color: "white"
			opacity: enabled ? (0.1 * highlighted + 0.1 * pressed + 0.1 * hovered) : 0.1
			radius: 5

			Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
		}
		Rectangle {
			anchors.fill: parent
			id: hover
			color: "transparent"
			opacity: enabled ? (0.2 * (hovered || pressed || highlighted)) : 0
			radius: 5

			// border.color: "#A5D6A7"
			border.color: "white"
			border.width: 1

			Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
		}
	}
}
