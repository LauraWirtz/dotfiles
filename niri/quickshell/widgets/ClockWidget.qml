// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	property bool minimized

	height: minimized ? 32 : 56

	text: Time.time
	color: minimized ? Material.color(Material.Grey, Material.Shade500) : Material.color(Material.Green, Material.Shade200)
	font.pixelSize: minimized ? 18 : 32
	font.weight: minimized ? 300 : 200
	lineHeight: 0.8
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter
	textFormat: Text.PlainText
	renderType: Text.QtRendering

	Behavior on height { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on color { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on font.pixelSize { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on font.weight { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
}
