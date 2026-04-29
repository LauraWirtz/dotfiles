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

		ColumnLayout {
			spacing: 0

			RowLayout {
				spacing: 0

				RoundButton {
					icon.name: QuodlibetService.playState == "playing" ? "media-playback-pause" : "media-playback-start"
					icon.width: 24
					icon.height: 24
					flat: true

					onClicked: QuodlibetService.playState == "playing" ? QuodlibetService.pause() : QuodlibetService.play()
				}
				RoundButton {
					icon.name: "media-skip-backward"
					icon.width: 24
					icon.height: 24
					flat: true

					enabled: canGoPrevious

					onClicked: QuodlibetService.previous()
				}
				RoundButton {
					icon.name: "media-skip-forward"
					icon.width: 24
					icon.height: 24
					flat: true

					enabled: canGoNext

					onClicked: QuodlibetService.next()
				}
			}

			RowLayout {
				Layout.alignment: Qt.AlignHCenter
				spacing: 0
				Repeater {
					model: [0.2, 0.4, 0.6, 0.8, 1]
					RatingStar {
					}
				}
			}
		}
		Text {
			Layout.alignment: Qt.AlignHCenter
			Layout.fillWidth: true

			color: "white"
			font.pixelSize: 16
			textFormat: Text.PlainText
			elide: Text.ElideRight
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter

			text: QuodlibetService.current.title + "\n" + QuodlibetService.current.albumartist + "\n" + QuodlibetService.current.album + (QuodlibetService.current.date ? " (" + QuodlibetService.current.date + ")" : "")
		}
	}
	RowLayout {
		Layout.fillWidth: true
		Text {
			Layout.alignment: Qt.AlignHCenter

			color: "white"
			font.pixelSize: 16
			textFormat: Text.PlainText

			text: formatDuration(QuodlibetService.current.length * QuodlibetService.progress)
		}
		Slider {
			Layout.fillWidth: true

			from: 0
			to: 1
			stepSize: 0.01

			value: QuodlibetService.progress
			Behavior on value { NumberAnimation { duration: 1000; easing.type: Easing.Linear } }
		}
		Text {
			Layout.alignment: Qt.AlignHCenter

			color: "white"
			font.pixelSize: 16
			textFormat: Text.PlainText

			text: formatDuration(QuodlibetService.current.length * (1 - QuodlibetService.progress))
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
