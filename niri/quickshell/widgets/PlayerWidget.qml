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

	component PlayerDelegate: ColumnLayout {
		width: list.contentWidth

		spacing: 0
		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			spacing: 0
			RoundButton {
				id: playerIcon
				icon.name: getIconNameFromDesktopEntry(model.desktopEntry)
				icon.color: "transparent"
				icon.width: 24
				icon.height: 24
				flat: true
				enabled: false
			}
			RoundButton {
				icon.name: model.isPlaying ? "media-playback-pause" : "media-playback-start"
				icon.width: 24
				icon.height: 24
				flat: true

				onClicked: togglePlaying()
			}
			RoundButton {
				icon.name: "media-skip-backward"
				icon.width: 24
				icon.height: 24
				flat: true

				enabled: canGoPrevious

				onClicked: { previous(); play() }
			}
			RoundButton {
				icon.name: "media-skip-forward"
				icon.width: 24
				icon.height: 24
				flat: true

				enabled: canGoNext

				onClicked: { next(); play() }
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
		spacing: -8

		model: Mpris.players.values
		delegate: PlayerDelegate {}
	}

	function getIconNameFromDesktopEntry(entry) {
		return DesktopEntries.heuristicLookup(entry).icon
	}
}
