import QtQuick
import QtQuick.Controls.Basic

Rectangle {
	id:root

	property bool show

	property alias name: button.icon.name

	property alias icon_width: button.icon.width
	property alias icon_height: button.icon.height
	property real topPadding: 8
	property real bottomPadding: 8
	property real leftPadding: 24
	property real rightPadding: 24

	signal clicked

	width: icon_width + leftPadding + rightPadding
	height: icon_height + topPadding + bottomPadding

	topLeftRadius: 8
	topRightRadius: 8

	color: "transparent"

	states: [
		State {
			name: "ENABLED"
			when: (root.show)
			PropertyChanges { root.color: "#202326" }
		}
	]

	transitions: Transition {
		ColorAnimation { properties: "root.color"; easing.type: Easing.InOutQuad; duration: 150 }
	}

	Item {
		id: position
		x: leftPadding + icon_width/2
		y: topPadding + icon_height/2
	}

	RoundButton {
		anchors.horizontalCenter: position.horizontalCenter
		anchors.verticalCenter: position.verticalCenter
		id: button
		padding: 0
		background: {}

	}

	MouseArea {
		id: handler
		anchors.fill: parent
		onClicked: root.clicked()
	}
}
