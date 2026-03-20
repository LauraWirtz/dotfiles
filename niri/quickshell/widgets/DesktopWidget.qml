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
	property int size: 24
	property alias spacing: list.spacing

	component DesktopEntryDelegate: Button {
		Material.roundedScale: root.display == AbstractButton.IconOnly ? Material.SmallScale : Material.FullScale
		id: button
		padding: 0

		Layout.alignment: root.alignment

		font.pixelSize: 20
		font.weight: 300

		icon.name: DesktopService.customIcons(modelData.icon)
		icon.color: "transparent"
		icon.width: root.size
		icon.height: root.size
		flat: true
		display: root.display

		text: DesktopService.customNames(modelData.name)

		onClicked: {
			Niri.spawn(modelData.command)
			PopupService.currentPopup = ""
		}
	}

	ListView {

		id: list

		anchors.fill: parent
		clip: list.interactive

		implicitHeight: contentHeight

		delegate: DesktopEntryDelegate {}
	}
}
