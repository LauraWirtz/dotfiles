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
		spacing: -8

		Button {
			icon.name: model.batteryAvailable ? batteryIconName() : "battery-000"
			icon.width: 24
			icon.height: 24
			padding: 0

			enabled: model.batteryAvailable
			background: {}
		}
		Button {
			icon.name: model.icon+"-symbolic"
			icon.width: 24
			icon.height: 24
			padding: 0

			enabled: model.batteryAvailable
			background: {}
		}
		Text {
			Layout.horizontalStretchFactor: 1
			Layout.fillWidth: true
			color: model.connected ? "white" : "#9E9E9E"
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

		function batteryIconName(): string {
			const number = (model.battery * 100).toString().padStart(3, "0").replace(/\d$/, "0")
			console.log(number)
			return "battery-"+number
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
