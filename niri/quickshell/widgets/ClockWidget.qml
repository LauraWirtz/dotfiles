// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	property bool minimized

	text: Time.time
	color: minimized ? TlpService.profile == "performance" ?  Material.color(Material.Red, Material.Shade200) : Material.color(Material.Green, Material.Shade200) : Material.color(Material.Grey, Material.Shade500)
	font.pixelSize: minimized ? 18 : 32
	font.weight: minimized ? TlpService.profile == "performance" ? 400 : 300 : 200
	lineHeight: 0.8
	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter
	textFormat: Text.PlainText
	renderType: Text.QtRendering

	Behavior on color { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on font.pixelSize { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on font.weight { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
}
