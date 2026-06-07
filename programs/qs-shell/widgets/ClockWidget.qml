// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	text: Time.time
	textFormat: Text.PlainText

	color: "white"
	font.pixelSize: 20
	font.weight: 300
	opacity: 0.67
}
