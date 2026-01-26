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
	name: "settings"
	icon.name: "applications-system-symbolic"
	content:
	ColumnLayout {
		anchors.centerIn: parent
		spacing: 16
		VolumeWidget {}
		BrightnessWidget {}
		BluelightWidget {}
		GridLayout {
			columnSpacing: 16
			KeyboardLayoutWidget {}
			InputPlumberWidget { Layout.fillWidth: false }
		}
		PlayerWidget {}
	}
}
