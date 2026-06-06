// Bar.qml
import QtQuick
import QtQuick.Controls
import "../"

import QtQuick.Controls.Basic

Button {
	id: root

	background: Rectangle {
		id: background
		radius: KeyboardService.rounding
		color: "#292c30"

		border.color: "#292c30"
		border.width: 1

	}

	states: [
		State {
			name: "ACTIVE"
			PropertyChanges {background.border.color: "#A5D6A7"}
			PropertyChanges {background.color: "#3c4642"}
		}
	]
	transitions: [
		Transition {
			from: "ACTIVE"
			ColorAnimation { properties: "background.border.color"; easing.type: Easing.OutQuad; duration: 100 }
			ColorAnimation { properties: "background.color"; easing.type: Easing.OutQuad; duration: 100 }
		},
	]
}
