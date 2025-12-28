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

Rectangle {
	id: root
	required property bool bluetoothMenu

	color: "transparent"
	// Layout.preferredHeight: 100
	Layout.preferredHeight: 0
	Layout.fillWidth: true

	states: [
		State {
			name: "ENABLED"
			when: (root.bluetoothMenu)
			PropertyChanges { root.Layout.preferredHeight: list.contentHeight }
		}
	]

	transitions: Transition {
		NumberAnimation { properties: "root.Layout.preferredHeight"; easing.type: Easing.InOutQuad; duration: 150 }
	}


	component BluetoothDeviceDelegate: RowLayout {

		width: list.width
		// height: 40

		Text {
			Layout.horizontalStretchFactor: 1
			Layout.leftMargin: 16
			color: "white"

			text: model.name+" ("+model.address+")"
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1

			text: "Connect"
			flat: true
			enabled: !model.connected

			onClicked: model.connect()
		}
		Button {
			Layout.alignment: Qt.AlignRight
			Layout.horizontalStretchFactor: -1
			Layout.rightMargin: 16

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

		contentWidth: width
		contentHeight: contentItem.childrenRect.height
		clip: true

		model: Bluetooth.devices.values
		delegate: BluetoothDeviceDelegate {}
	}
}
