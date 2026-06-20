import QtQuick
import QtQuick.Controls.Basic

Slider {
	id: control
	value: 0.5

	background: Item {
		implicitWidth: 200
		implicitHeight: 26
		width: control.availableWidth
		height: implicitHeight
		Rectangle {
			x: control.leftPadding
			y: control.topPadding + control.availableHeight / 2 - height / 2
			width: control.availableWidth
			height: 10
			radius: 5
			color: "#A5D6A7"
			opacity: control.hovered ? 0.2 : 0.15
			Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
		}
		Rectangle {
			x: control.leftPadding
			y: control.topPadding + control.availableHeight / 2 - height / 2
			width: control.visualPosition * (parent.width - 10) + 10
			height: 10
			color: "#A5D6A7"
			radius: 5
			opacity: control.hovered ? 1 : 0.5
			Behavior on opacity { NumberAnimation { easing: Easing.OutQuad; duration: 50 } }
		}
	}

	handle: {}
}
