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


RowLayout {
	id: root
	Layout.fillWidth: true

	clip: true

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
