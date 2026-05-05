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
		RowLayout {
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
	Rectangle {
		Layout.fillWidth: true
		implicitHeight: 26
		color: "black"
		radius: 13

		Item {
			id: quodClip
			x: 13
			implicitHeight: 26
			implicitWidth: parent.width - 26
			clip: true

			Text {
				id: quodText
				color: "white"
				font.family: "Doto"
				font.pixelSize: 22
				font.weight: 800

				text : QuodlibetService.current ? `${QuodlibetService.current.albumartist} - ${QuodlibetService.current.title} - ${QuodlibetService.current.album} | ${QuodlibetService.current.albumartist} - ${QuodlibetService.current.title} - ${QuodlibetService.current.album} | ` : ""

				NumberAnimation on x {
					running: true
					loops: Animation.Infinite
					duration: quodText.contentWidth ? (quodText.contentWidth * 5) : 5000

					from: 0; to: -0.5*quodText.contentWidth
				}
			}
			Rectangle {
				anchors.fill: parent
				gradient: Gradient {
					orientation: Gradient.Horizontal
					GradientStop { position: 0.0; color: "black" }
					GradientStop { position: 0.05; color: "transparent" }
					GradientStop { position: 0.95; color: "transparent" }
					GradientStop { position: 1.0; color: "black" }
				}
			}
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
