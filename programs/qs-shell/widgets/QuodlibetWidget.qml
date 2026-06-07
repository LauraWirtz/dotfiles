// ClockWidget.qml
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

ColumnLayout {
	spacing: 0

	RowLayout {
		Layout.fillWidth: true
		spacing: 0

		RoundButton {
			icon.name: QuodlibetService.playState == "playing" ? "media-playback-pause" : "media-playback-start"
			icon.width: 24
			icon.height: 24

			onClicked: QuodlibetService.playState == "playing" ? QuodlibetService.pause() : QuodlibetService.play()
		}
		Button {
			icon.name: "media-skip-backward"
			icon.width: 24
			icon.height: 24

			onClicked: QuodlibetService.previous()
		}
		Button {
			icon.name: "media-skip-forward"
			icon.width: 24
			icon.height: 24

			onClicked: QuodlibetService.next()
		}
		Item {
			Layout.fillWidth: true
			Layout.horizontalStretchFactor: 1
		}
		RowLayout {
			Layout.fillWidth: false
			Layout.alignment: Qt.AlignHCenter
			spacing: 0
			Repeater {
				model: [
					{rating: 0.1, left: true},
					{rating: 0.2, left: false},
					{rating: 0.3, left: true},
					{rating: 0.4, left: false},
					{rating: 0.5, left: true},
					{rating: 0.6, left: false},
					{rating: 0.7, left: true},
					{rating: 0.8, left: false},
					{rating: 0.9, left: true},
					{rating: 1.0, left: false},]
				RatingStar {}
			}
		}
	}
	Text {
		Layout.alignment: Qt.AlignHCenter

		color: "white"
		font.pixelSize: 16
		textFormat: Text.PlainText

		text: QuodlibetService.current.title
	}
	Text {
		Layout.alignment: Qt.AlignHCenter

		color: "white"
		font.pixelSize: 16
		textFormat: Text.PlainText

		text: QuodlibetService.current.albumartist
	}
	Text {
		Layout.alignment: Qt.AlignHCenter

		color: "white"
		font.pixelSize: 16
		textFormat: Text.PlainText

		text: QuodlibetService.current.album
	}
	RowLayout {
		Layout.fillWidth: true
		Text {
			Layout.alignment: Qt.AlignHCenter

			color: "white"
			font.pixelSize: 16
			textFormat: Text.PlainText

			text: QuodlibetService.current ? formatDuration(QuodlibetService.current.length * QuodlibetService.progress) : "00:00"
		}
		Slider {
			id: slider
			Layout.fillWidth: true

			from: 0
			to: 1
			stepSize: 0.01

			value: QuodlibetService.progress
			Behavior on value { NumberAnimation { duration: 1000; easing.type: Easing.Linear } }
			onMoved: {
				valueCache = value
				debounce.restart()
			}

			property real valueCache: 0

			Timer {
				id: debounce
				interval: 200; running: false; repeat: false
				onTriggered: QuodlibetService.seek(formatDuration(QuodlibetService.current.length * slider.valueCache))
			}
		}
		Text {
			Layout.alignment: Qt.AlignHCenter

			color: "white"
			font.pixelSize: 16
			textFormat: Text.PlainText

			text: QuodlibetService.current ? formatDuration(QuodlibetService.current.length * (1 - QuodlibetService.progress)) : "00:00"
		}
	}

	function formatDuration(duration): string {
		const minutes = Math.floor(duration / 60)
		const seconds = duration - minutes * 60

		const minutesString = minutes.toFixed(0).padStart(2,"0")
		const secondsString = seconds.toFixed(0).padStart(2,"0")

		return minutesString + ":" + secondsString
	}
}
