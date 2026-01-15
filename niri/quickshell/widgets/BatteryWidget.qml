// ClockWidget.qml
import QtQuick
import "../services"

Text {
	id: root
	text: Math.min(Battery.percentage, 99).toString().padStart(2,"0")+"%"// ("+Battery.timeRemaining+")"
	color: "#9E9E9E"
	font.pixelSize: 20
	font.weight: 200
	textFormat: Text.PlainText

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
