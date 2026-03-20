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
	Material.accent: Material.Green

	// Layout.fillWidth: true
	// implicitWidth: childrenRect.width
	// implicitHeight: childrenRect.height

	// spacing: -8

	component BluetoothDeviceDelegate: RowLayout {
		width: list.contentWidth
		spacing: 0

		Button {
			icon.name: modelData.batteryAvailable ? batteryIconName() : "battery-000"
			icon.width: 24
			icon.height: 24
			padding: 0
			Layout.leftMargin: -12

			enabled: modelData.batteryAvailable
			background: {}
		}
		Button {
			icon.name: modelData.icon+"-symbolic"
			icon.width: 24
			icon.height: 24
			padding: 0
			Layout.leftMargin: -16

			enabled: modelData.connected
			background: {}
		}
		Text {
			Layout.horizontalStretchFactor: 1
			Layout.fillWidth: true
			color: modelData.connected ? "white" : "#9E9E9E"
			textFormat: Text.PlainText

			text: modelData.name || modelData.address
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			padding: 0

			text: "Connect"
			flat: true
			enabled: !modelData.connected && Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled

			onClicked: modelData.paired ? connect() : pair()
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			padding: 0

			text: "Disconnect"
			flat: true
			enabled: modelData.connected

			onClicked: disconnect()
		}

		function batteryIconName(): string {
			const number = (modelData.battery * 100).toString().padStart(3, "0").replace(/\d$/, "0")
			console.log(number)
			return "battery-"+number
		}
	}

	// RowLayout {
	// 	CheckBox {
	// 		text: "Enable"
	// 		checked: Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled
	// 		enabled: Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled ||
	// 			Bluetooth.defaultAdapter.state == BluetoothAdapterState.Disabled
	// 		onClicked: {
	// 			if(Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled) {
	// 				Bluetooth.defaultAdapter.enabled = false
	// 			} else if(Bluetooth.defaultAdapter.state == BluetoothAdapterState.Disabled) {
	// 				Bluetooth.defaultAdapter.enabled = true
	// 			}
	// 		}
	// 	}
	// 	CheckBox {
	// 		text: "Scan"
	// 		checked: Bluetooth.defaultAdapter.discovering
	// 		enabled: Bluetooth.defaultAdapter.state == BluetoothAdapterState.Enabled
	// 		onClicked: Bluetooth.defaultAdapter.discovering = !Bluetooth.defaultAdapter.discovering
	// 	}
	// }


	ListView {
		id: list

		// anchors.fill: parent
		// implicitHeight: contentItem.implicitHeight
		Layout.fillWidth: true
		// Layout.fillHeight: true
		Layout.preferredWidth:
			contentItem.children.reduce((acc, el) => {
				return Math.max(el.implicitWidth, acc)
			}, 0)
		Layout.preferredHeight: contentItem.childrenRect.height
		clip: true

		contentWidth: width
		contentHeight: height
		spacing: -8
		topMargin: 0
		bottomMargin: 0

		model: Bluetooth.devices.values.filter(device => {
			return device.paired
		})
		delegate: BluetoothDeviceDelegate {}
	}
}
