import QtQuick
import QtQuick.Controls
import "../services"

import QtQuick.Controls.Basic

Item {
	id: root
	implicitWidth: 12 + 8
	implicitHeight: 24 + 16
	clip: true

	required property var modelData

	RoundButton {
		id: foreground

		anchors.horizontalCenter: modelData.left ? parent.right : parent.left
		anchors.verticalCenter: parent.verticalCenter
		implicitWidth: 24 + 16
		implicitHeight: 24 + 16
		flat: true

		background: Item {
		}

		icon.name: "starred"
		icon.width: 24
		icon.height: 24
		icon.color: {
			if(ratingWidget.containsMouse) {
				return ratingWidget.mouseX/ratingWidget.width + 0.1 >= modelData.rating ? "#A5D6A7" : "black"
			} else if(QuodlibetService.current) {
				return QuodlibetService.current.rating >= modelData.rating ? "#A5D6A7" : "#90000000"
			}
			return "black"
		}

		onClicked: QuodlibetService.rate(modelData.rating)
	}
}
