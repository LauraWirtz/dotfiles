// ClockWidget.qml
import QtQuick
import "../services"

import QtQuick.Controls.Material

Text {
	id: root
	text: Time.time
	textFormat: Text.PlainText

	color: "white"
	font.pixelSize: 20
	font.weight: 400
	// opacity: 0.67

	SequentialAnimation {
		running: Time.time.includes("22:")
		alwaysRunToEnd: true
		loops: Animation.Infinite
		ColorAnimation { target: root; property: "color"; from: "white"; to: "red"; easing.type: Easing.OutQuad; duration: 100 }
		ColorAnimation { target: root; property: "color"; from: "red"; to: "white"; easing.type: Easing.OutQuad; duration: 900 }
	}
}
