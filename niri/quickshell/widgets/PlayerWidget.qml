// ClockWidget.qml
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

Item {
	id: root
	clip: true
	required property bool show

	Layout.preferredHeight: 0
	Layout.fillWidth: true

	states: [
		State {
			name: "ENABLED"
			when: (root.show)
			PropertyChanges { root.Layout.preferredHeight: root.children[0].implicitHeight }
		}
	]

	transitions: Transition {
		NumberAnimation { properties: "root.Layout.preferredHeight"; easing.type: Easing.InOutQuad; duration: 150 }
	}

	RowLayout {
		IconButton {
			source: "/home/laura/.local/share/icons/Breeze-dark/actions/24/media-skip-backward.svg"
			icon_width: 24
			icon_height: 24

			topPadding: 8
			bottomPadding: 8
			leftPadding: 16
			rightPadding: 16

			onTapped: {buttonRow.state = buttonRow.state == "WIFI" ? "NONE" : "WIFI"}
		}

		IconButton {
			source: "/home/laura/.local/share/icons/Breeze-dark/actions/24/media-playback-start.svg"
			icon_width: 24
			icon_height: 24

			topPadding: 8
			bottomPadding: 8
			leftPadding: 16
			rightPadding: 16

			onTapped: {buttonRow.state = buttonRow.state == "WIFI" ? "NONE" : "WIFI"}
		}

		IconButton {
			source: "/home/laura/.local/share/icons/Breeze-dark/actions/24/media-skip-forward.svg"
			icon_width: 24
			icon_height: 24

			topPadding: 8
			bottomPadding: 8
			leftPadding: 16
			rightPadding: 16

			onTapped: {buttonRow.state = buttonRow.state == "WIFI" ? "NONE" : "WIFI"}
		}
		Text {
			color: "white"
			text: "playing title"
		}
	}
}
