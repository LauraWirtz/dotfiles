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
	Material.theme: Material.Dark
	Material.accent: Material.Pink


	width: parent.width
	implicitHeight: 200

	component BluetoothDeviceDelegate: RowLayout {

		width: list.width

		Text {
			color: "white"

			text: model.name+" ("+model.address+")"
		}
		Button {
			Layout.alignment: Qt.AlignRight

			text: "Connect"
			flat: true
			enabled: !model.connected

			onClicked: model.connect()
		}
		Button {
			Layout.alignment: Qt.AlignRight

			text: "Disconnect"
			flat: true
			enabled: model.connected

			onClicked: disconnect()
		}
	}

	ListView {
		id: list
		anchors.fill: parent
		model: Bluetooth.devices.values
		delegate: BluetoothDeviceDelegate {}
	}
}
