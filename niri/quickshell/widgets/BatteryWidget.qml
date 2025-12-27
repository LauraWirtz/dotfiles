// ClockWidget.qml
import QtQuick
import "../services"

Text {
	id: root
	text: Battery.percentage+"% ("+Battery.timeRemaining+")"
	color: "white"
	font.pixelSize: 20
	font.weight: 200

	states: [
		State {
			name: "EXCESS"
			when: (Battery.percentage >= 80)
			PropertyChanges { root.color: "#80ffff"}
		},
		State {
			name: "WARN"
			when: (50 > Battery.percentage && Battery.percentage >= 20)
			PropertyChanges { root.color: "#ffff80"}
		},
		State {
			name: "CRITICAL"
			when: (20 > Battery.percentage)
			PropertyChanges { root.color: "#ff8080"}
		}
	]
}
