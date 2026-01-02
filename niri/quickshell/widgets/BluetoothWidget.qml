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

	Layout.preferredHeight: list.contentHeight
	implicitHeight: list.contentHeight
	Layout.fillWidth: true

	component BluetoothDeviceDelegate: RowLayout {

		width: list.width

		Text {
			Layout.horizontalStretchFactor: 1
			Layout.fillWidth: true
			color: "white"
			textFormat: Text.PlainText

			text: model.name+" ("+model.address+")"
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			Layout.fillWidth: true
			padding: 0

			text: "Connect"
			flat: true
			enabled: !model.connected

			onClicked: connect()
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			Layout.fillWidth: true
			padding: 0

			text: "Disconnect"
			flat: true
			enabled: model.connected

			onClicked: disconnect()
		}
	}

	ListView {
		Material.theme: Material.Dark
		Material.accent: Material.Pink

		id: list

		anchors.fill: parent
		implicitHeight: contentHeight

		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		interactive: false
		spacing: -8

		model: Bluetooth.devices.values
		delegate: BluetoothDeviceDelegate {}
	}
}
