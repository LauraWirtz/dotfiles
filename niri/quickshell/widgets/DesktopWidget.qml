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
	property alias flow: list.flow
	property alias interactive: list.interactive

	property var display: AbstractButton.TextBesideIcon
	property var alignment: Qt.AlignVCenter | Qt.AlignLeft
	property int size: 32
	property alias cellHeight: list.cellHeight

	component DesktopEntryDelegate: Button {
		Material.roundedScale: Material.SmallScale
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

	GridView {

		id: list

		anchors.fill: parent
		clip: list.interactive
		cellWidth: contentItem.children.reduce((acc, el) => {
			return Math.max(el.implicitWidth, acc)
		}, 0)

		implicitHeight: contentHeight

		delegate: DesktopEntryDelegate {}
	}
}
