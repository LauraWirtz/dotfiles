// Bar.qml
import Quickshell
import Quickshell.Wayland
import Quickshell.WindowManager
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Shapes
import "./items"
import "./services"
import "./widgets"

import QtQuick.Controls.Material

PanelWindow {
	id: root
	required property var modelData
	screen: modelData

	color: "transparent"

	// anchors.left: true
	// anchors.right: true
	anchors.bottom: true
	margins.bottom: 10
	implicitWidth: Math.min(screen.width - 20, 1260)
	implicitHeight: 52

	WlrLayershell.layer: WlrLayer.Top
	WlrLayershell.namespace: "qs-taskbar"

	MouseArea {
		Material.theme: Material.Dark
		Material.accent: Material.Blue
		id: mouseArea

		anchors.fill: parent

		opacity: 0.85

		acceptedButtons: Qt.LeftButton | Qt.BackButton | Qt.ForwardButton
		onClicked: event => {
			switch (event.button) {
				case Qt.BackButton:
					Niri.focusWorkspaceDown();
					break;
				case Qt.ForwardButton:
					Niri.focusWorkspaceUp();
					break;
			}
		}
		onWheel: event => {
			if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
			else { Niri.focusColumnRight() }
		}

		Rectangle {
			anchors.fill: parent
			color: "#292c30"
		}

		RowLayout {
			anchors.centerIn: parent
			id: content
			width: Math.min(root.width, 1920)

			spacing: 0
			WindowListWidget {screen: root.screen.name}
			// Item {width: 52}
			Item{Layout.fillWidth: true; Layout.horizontalStretchFactor: 1}
			DesktopMenuWidget {}
			WindowActionWidget {}
			// Separator {inset: 0}
			TlpWidget {}
			MenuWithButton {
				icon.name: "settings-configure"
				content: ColumnLayout {
					Material.theme: Material.Dark
					Material.accent: Material.Green
					spacing: 16
					BluetoothWidget {}
					RowLayout {
						InputPlumberWidget {}
						KeyboardLayoutWidget {}
					}
					BluelightWidget {}
					BrightnessWidget {}
					VolumeWidget {}
					Separator { vertical: true }
					Loader {
						Layout.fillWidth: true
						active: root.screen.name != "eDP-1"
						sourceComponent: QuodlibetWidget {}
					}
				}
			}
			MenuWithButton {
				text: Time.date
				content: CalendarWidget {}
			}
		}
		Button {
			anchors.centerIn: parent
			width: 70 + 13
			height: 52
			flat: true
			onClicked: Niri.toggleOverview()
		}
	}
}
