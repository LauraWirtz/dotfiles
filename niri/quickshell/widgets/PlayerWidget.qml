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

Item {
	id: root

	implicitHeight: list.contentHeight
	Layout.fillWidth: true

	component PlayerDelegate: RowLayout {
		width: list.contentWidth

		spacing: -12

		RoundButton {
			Layout.leftMargin: -8

			icon.name: "media-skip-backward"
			icon.width: 24
			icon.height: 24
			padding: 0
			flat: true

			enabled: canGoPrevious

			onClicked: { previous(); play() }
		}
		RoundButton {
			icon.name: model.isPlaying ? "media-playback-pause" : "media-playback-start"
			icon.width: 24
			icon.height: 24
			padding: 0
			flat: true

			onClicked: togglePlaying()
		}
		RoundButton {
			icon.name: "media-skip-forward"
			icon.width: 24
			icon.height: 24
			padding: 0
			flat: true

			enabled: canGoNext

			onClicked: { next(); play() }
		}
		Text {
			color: "white"
			font.pixelSize: 16
			textFormat: Text.PlainText
			elide: Text.ElideRight
			Layout.fillWidth: true
			Layout.leftMargin: 20
			// Layout.rightMargin: 16

			text: (trackAlbumArtist || trackArtist) + " - " + model.trackTitle
		}
	}

	ListView {
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: list

		anchors.fill: parent

		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		height: contentHeight
		interactive: false
		spacing: -8

		model: Mpris.players.values
		delegate: PlayerDelegate {}
	}
}
