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

	color: root.screen.name == "eDP-1" ? "black" : "transparent"

	anchors.bottom: true
	margins.bottom: -5
	implicitWidth: 1280
	implicitHeight: 52

	WlrLayershell.layer: WlrLayer.Top
	WlrLayershell.namespace: "qs-taskbar"

	Loader {
		anchors.fill: parent
		id: background
		Behavior on opacity { NumberAnimation { duration: 125 } }
		active: root.screen.name != "eDP-1"
		sourceComponent: Rectangle {
			anchors.fill: parent
			radius: 8
			color: "#292c30"
		}
	}
	MouseArea {
		id: mouseArea

		anchors.fill: parent

		acceptedButtons: Qt.LeftButton | Qt.BackButton | Qt.ForwardButton
		hoverEnabled: true
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
		onEntered: background.opacity = 1
		onExited: background.opacity = 0.85
		RowLayout {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			id: content

			Material.theme: Material.Dark
			Material.accent: Material.Blue

			spacing: 0
			Item{
				width: 80 + 13 + 13
			}
			WindowListWidget {screen: root.screen.name}
			Item {
				Layout.fillWidth: true
				Layout.horizontalStretchFactor: 1
			}
			DesktopMenuWidget {}
			WindowActionWidget {}
			Separator {inset: 0}
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
	}
}
