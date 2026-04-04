// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	id: root

	property bool minimized

	text: Math.min(Battery.percentage, 99).toString().padStart(2,"0")+"%"
	color: Material.color(Material.Grey, Material.Shade500)
	font.pixelSize: minimized ? 18 : 32
	font.weight: minimized ? 300 : 200
	lineHeight: 0.8
	horizontalAlignment: Text.AlignHCenter
	textFormat: Text.PlainText
	renderType: Text.QtRendering

	Behavior on font.pixelSize { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }
	Behavior on font.weight { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }

	states: [
		State {
			name: "BAT90"
			when: (Battery.percentage >= 90)
			PropertyChanges { root.color: "#00BCD4"}
		},
		State {
			name: "BAT80"
			when: (Battery.percentage >= 80)
			PropertyChanges { root.color: "#009688"}
		},
		State {
			name: "BAT50"
			when: (Battery.percentage >= 50)
			PropertyChanges { root.color: "#9E9E9E"}
		},
		State {
			name: "BAT40"
			when: (Battery.percentage >= 40)
			PropertyChanges { root.color: "#FFEB3B"}
		},
		State {
			name: "BAT30"
			when: (Battery.percentage >= 30)
			PropertyChanges { root.color: "#FFC107"}
		},
		State {
			name: "BAT20"
			when: (Battery.percentage >= 20)
			PropertyChanges { root.color: "#FF9800"}
		},
		State {
			name: "BAT10"
			when: (Battery.percentage >= 10)
			PropertyChanges { root.color: "#FF5722"}
		},
		State {
			name: "BAT00"
			when: (Battery.percentage >= 0)
			PropertyChanges { root.color: "#F44336"}
		},
	]
}
