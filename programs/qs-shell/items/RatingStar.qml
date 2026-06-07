import QtQuick
import QtQuick.Controls
import "../services"

import QtQuick.Controls.Basic

Item {
	implicitWidth: 16
	implicitHeight: 24
	clip: true

	RoundButton {
		id: background

		anchors.horizontalCenter: modelData.left ? parent.right : parent.left
		anchors.verticalCenter: parent.verticalCenter

		background: Item {
		}

		icon.name: "starred"
		icon.width: 24
		icon.height: 24
		icon.color: QuodlibetService.current && QuodlibetService.current.rating >= modelData.rating ? "#FFF59D" : "black"
		flat: true
	}
	RoundButton {
		id: foreground

		anchors.horizontalCenter: modelData.left ? parent.right : parent.left
		anchors.verticalCenter: parent.verticalCenter

		background: Item {
		}

		icon.name: "non-starred"
		icon.width: 24
		icon.height: 24
		icon.color: QuodlibetService.current && QuodlibetService.current.rating >= modelData.rating? "#FFEB3B" : "black"
		flat: true

		onClicked: QuodlibetService.rate(modelData.rating)
	}
}
