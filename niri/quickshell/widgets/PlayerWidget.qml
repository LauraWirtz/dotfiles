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
	Material.theme: Material.Dark
	Material.accent: Material.Pink

	implicitHeight: list.contentHeight
	implicitWidth: list.contentWidth
	Layout.fillWidth: true
	Layout.minimumHeight: list.contentHeight

	component PlayerDelegate: RowLayout {
		width: list.contentWidth

		spacing: 0

		RoundButton {
			id: playerIcon
			Layout.leftMargin: 0
			Layout.rightMargin: 4
			icon.name: getIconNameFromDesktopEntry(model.desktopEntry)
			icon.color: "transparent"
			icon.width: 32
			icon.height: 32
			padding: 0
			flat: true
			background: {}
		}
		RoundButton {
			Layout.leftMargin: -8
			Layout.rightMargin: -8

			icon.name: "media-skip-backward"
			icon.width: 24
			icon.height: 24
			padding: 0
			flat: true

			enabled: canGoPrevious

			onClicked: { previous(); play() }
		}
		RoundButton {
			Layout.leftMargin: -8
			Layout.rightMargin: -8
			icon.name: model.isPlaying ? "media-playback-pause" : "media-playback-start"
			icon.width: 24
			icon.height: 24
			padding: 0
			flat: true

			onClicked: togglePlaying()
		}
		RoundButton {
			Layout.leftMargin: -8
			Layout.rightMargin: 0
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
			// Layout.leftMargin: 12
			// Layout.rightMargin: 16

			text: (trackAlbumArtist || trackArtist) + " - " + model.trackTitle
		}
	}

	ListView {

		id: list

		anchors.fill: parent

		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		// height: contentHeight
		interactive: false
		// spacing: -8

		model: Mpris.players.values
		delegate: PlayerDelegate {}
	}

	function getIconNameFromDesktopEntry(entry) {
		return DesktopEntries.heuristicLookup(entry).icon
	}
}
