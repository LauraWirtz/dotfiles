// ClockWidget.qml
import Quickshell
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

	implicitWidth: list.contentItem.childrenRect.width
	implicitHeight: list.contentItem.childrenRect.height

	property alias model: list.model
	property alias orientation: list.orientation
	property alias interactive: list.interactive

	property var display: AbstractButton.TextBesideIcon
	property var alignment: Qt.AlignVCenter | Qt.AlignLeft
	property int size: 32

	component DesktopEntryDelegate: RowLayout {
		width: list.cellWidth
		height: list.cellHeight
		Button {
			id: button
			padding: 0

			Layout.alignment: root.alignment

			font.pixelSize: 20
			font.weight: 300

			icon.name: modelData.icon
			icon.color: "transparent"
			icon.width: root.size
			icon.height: root.size
			flat: true
			display: root.display

			text: DesktopService.customNames(modelData.name)

			onClicked: Niri.spawn(modelData.command)
		}
	}

	Connections {
		target: DesktopService

		function onUpdated() {
			list.model = root.model
		}
	}

	ListView {

		id: list

		anchors.fill: parent
		clip: list.interactive
		spacing: -8

		implicitHeight: contentHeight

		delegate: DesktopEntryDelegate {}
	}
}
