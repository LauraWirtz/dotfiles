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

ColumnLayout {
	id: root
	Material.theme: Material.Dark
	Material.accent: Material.Pink

	// Layout.fillWidth: true
	// implicitWidth: childrenRect.width
	// implicitHeight: childrenRect.height

	// spacing: -8

	component BluetoothDeviceDelegate: RowLayout {
		width: list.contentWidth
		spacing: 0

		Button {
			icon.name: model.batteryAvailable ? batteryIconName() : "battery-000"
			icon.width: 24
			icon.height: 24
			padding: 0
			Layout.leftMargin: -12

			enabled: model.batteryAvailable
			background: {}
		}
		Button {
			icon.name: model.icon+"-symbolic"
			icon.width: 24
			icon.height: 24
			padding: 0
			Layout.leftMargin: -16

			enabled: model.batteryAvailable
			background: {}
		}
		Text {
			Layout.horizontalStretchFactor: 1
			Layout.fillWidth: true
			color: model.connected ? "white" : "#9E9E9E"
			textFormat: Text.PlainText

			text: model.name || model.address
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			padding: 0

			text: "Connect"
			flat: true
			enabled: !model.connected && Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled

			onClicked: connect()
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			padding: 0

			text: "Disconnect"
			flat: true
			enabled: model.connected

			onClicked: disconnect()
		}
		CheckBox {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			padding: 0

			text: "Paired"
			checked: model.paired
			enabled: model.connected

			onClicked: model.paired = !model.paired
		}
		CheckBox {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			padding: 0

			text: "Trusted"
			checked: model.trusted
			enabled: model.connected

			onClicked: model.trusted = !model.trusted
		}

		function batteryIconName(): string {
			const number = (model.battery * 100).toString().padStart(3, "0").replace(/\d$/, "0")
			console.log(number)
			return "battery-"+number
		}
	}

	RowLayout {
		Switch {
			text: "Enable"
			checked: Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled
			enabled: Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled ||
				Bluetooth.defaultAdapter.state == BluetoothAdapterState.Disabled
			onClicked: {
				if(Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled) {
					Bluetooth.defaultAdapter.enabled = false
				} else if(Bluetooth.defaultAdapter.state == BluetoothAdapterState.Disabled) {
					Bluetooth.defaultAdapter.enabled = true
				}
			}
		}
		Switch {
			text: "Scan"
			checked: Bluetooth.defaultAdapter.discovering
			enabled: Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled
			onClicked: Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
		}
	}


	ListView {
		id: list

		// anchors.fill: parent
		// implicitHeight: contentItem.implicitHeight
		Layout.fillWidth: true
		// Layout.fillHeight: true
		Layout.preferredWidth: contentItem.childrenRect.width
		Layout.preferredHeight: contentItem.childrenRect.height
		clip: true

		contentWidth: width
		contentHeight: height
		spacing: -8
		topMargin: 0
		bottomMargin: 0

		model: Bluetooth.devices.values
		delegate: BluetoothDeviceDelegate {}
	}
}
