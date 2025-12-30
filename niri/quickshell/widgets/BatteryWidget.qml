// ClockWidget.qml
import QtQuick
import "../services"

Text {
	id: root
	text: Math.min(Battery.percentage, 99).toString().padStart(2,"0")+"%"
	color: "#a0a0a0"
	font.pixelSize: 20
	font.weight: 200

	states: [
		State {
			name: "EXCESS"
			when: (Battery.percentage >= 80)
			PropertyChanges { root.color: "#40ffff"}
		},
		State {
			name: "WARN"
			when: (50 > Battery.percentage && Battery.percentage >= 20)
			PropertyChanges { root.color: "#ffff40"}
		},
		State {
			name: "CRITICAL"
			when: (20 > Battery.percentage)
			PropertyChanges { root.color: "#ff4040"}
		}
	]
}
