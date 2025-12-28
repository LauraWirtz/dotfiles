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
	required property bool show

	Layout.preferredHeight: 0
	Layout.fillWidth: true

	states: [
		State {
			name: "ENABLED"
			when: (root.show)
			PropertyChanges { root.Layout.preferredHeight: list.contentHeight }
		}
	]

	transitions: Transition {
		NumberAnimation { properties: "root.Layout.preferredHeight"; easing.type: Easing.InOutQuad; duration: 150 }
	}


	component DesktopEntryDelegate: RowLayout {

		width: list.width

		Text {
			Layout.leftMargin: 16
			color: "white"
			font.pixelSize: 24
			font.weight: 200

			text: model.name

			TapHandler {
				gesturePolicy: TapHandler.ReleaseWithinBounds
				onTapped: Niri.spawn(model.command)
			}
		}
	}

	ListView {
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: list

		anchors.fill: parent

		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		clip: true

		model: DesktopEntries.applications.values
		delegate: DesktopEntryDelegate {}
	}
}
