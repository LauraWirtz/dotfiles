// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	text: Time.time
	textFormat: Text.PlainText

	color: TlpService.profile == "performance" ?  Material.color(Material.Red, Material.Shade200) : Material.color(Material.Green, Material.Shade200)
	font.pixelSize: 20
	font.weight: 300
}
