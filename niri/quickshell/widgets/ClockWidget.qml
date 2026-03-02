// ClockWidget.qml
import QtQuick
import "../services"

Text {
	text: Time.time
	color: Niri.inOverview ? "white" : "#9E9E9E"
	font.pixelSize: Niri.inOverview ? 32 : 18
	font.weight: 200
	lineHeight: 0.8
	horizontalAlignment: Text.AlignHCenter
	textFormat: Text.PlainText
	renderType: Text.QtRendering

	Behavior on color { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on font.pixelSize { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
}
