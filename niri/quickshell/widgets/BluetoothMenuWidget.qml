// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import "../items"
import "../services"
import "../widgets"

import QtQuick.Controls.Material

MenuWithButton {
	name: "bluetooth"
	icon.name: "network-bluetooth"
	color: Material.LightBlue
	content: BluetoothWidget {
		anchors.centerIn: parent
	}
}
