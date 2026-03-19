// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	property bool minimized

	text: Time.time
	color: Material.color(Material.Green, Material.Shade200)
	font.pixelSize: minimized ? 16 : 32
	font.weight: 200
	lineHeight: 0.8
	horizontalAlignment: Text.AlignHCenter
	textFormat: Text.PlainText
	renderType: Text.QtRendering

	Behavior on color { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on font.pixelSize { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
}
