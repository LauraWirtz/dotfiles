import QtQuick
import QtQuick.Controls
import "../services"

import QtQuick.Controls.Basic

Item {
	implicitWidth: 24
	implicitHeight: 24

	RoundButton {
		id: background

		anchors.centerIn: parent

		background: Item {
		}

		icon.name: "starred"
		icon.width: 24
		icon.height: 24
		icon.color: QuodlibetService.current.rating >= modelData ? "#FFF59D" : "black"
		flat: true
	}
	RoundButton {
		id: foreground

		anchors.centerIn: parent

		background: Item {
		}

		icon.name: "non-starred"
		icon.width: 24
		icon.height: 24
		icon.color: QuodlibetService.current.rating >= modelData ? "#FFEB3B" : "black"
		flat: true

		onClicked: QuodlibetService.rate(modelData)
	}
}
