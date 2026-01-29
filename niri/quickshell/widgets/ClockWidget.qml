// ClockWidget.qml
import QtQuick
import "../services"

Text {
	text: Time.time+"\n"+Time.date
	color: Niri.inOverview ? "white" : "#9E9E9E"
	font.pixelSize: 18
	font.weight: Niri.inOverview ? 300 : 200
	lineHeight: 0.8
	horizontalAlignment: Text.AlignHCenter
	textFormat: Text.PlainText
	renderType: Text.QtRendering

	Behavior on color { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }
}
