// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	text: Time.time

	color: TlpService.profile == "performance" ?  Material.color(Material.Red, Material.Shade200) : Material.color(Material.Green, Material.Shade200)
	// font.family: "Silkscreen"
	font.pixelSize: 20
	// font.weight: 400

	horizontalAlignment: Text.AlignHCenter
	verticalAlignment: Text.AlignVCenter
	textFormat: Text.PlainText
}
