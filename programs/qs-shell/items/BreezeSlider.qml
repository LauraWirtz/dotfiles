import QtQuick
import QtQuick.Controls.Basic

Slider {
	id: control
	value: 0.5

	background: Item {
		implicitWidth: 200
		implicitHeight: 32
		width: control.width
		height: control.height
		Rectangle {
			x: control.leftPadding
			y: control.topPadding
			width: control.availableWidth
			height: control.availableHeight
			radius: 5
			color: "white"
			opacity: control.hovered ? 0.1 : 0.05
			Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
		}
		Rectangle {
			x: control.leftPadding
			y: control.topPadding
			width: control.availableWidth
			height: control.availableHeight
			radius: 5
			color: "transparent"
			border.color: "white"
			border.width: 1
			opacity: control.hovered ? 0.3 : 0.2
			Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
		}
		Rectangle {
			x: control.leftPadding + 5
			y: control.topPadding + 5
			width: control.visualPosition * (control.availableWidth - 2*5 - 4) + 4
			height: control.availableHeight - 2*5
			color: "#A5D6A7"
			radius: 2
			opacity: control.hovered ? 1 : 0.5
			Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
		}
	}

	handle: {}
}
