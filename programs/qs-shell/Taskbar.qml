// Bar.qml
import Quickshell
import Quickshell.Wayland
// import Quickshell.WindowManager
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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

	Rectangle {
		anchors.fill: parent
		color: "#292c30"
		radius: 5
		opacity: 0.75
		// border.color: Material.color(Material.Red, Material.Shade200)
		border.color: "red"
		border.width: TlpService.profile == "performance" ? 2 : 0
	}

	MouseArea {
		Material.theme: Material.Dark
		Material.accent: Material.Blue
		id: mouseArea

		anchors.fill: parent

		acceptedButtons: Qt.LeftButton | Qt.BackButton | Qt.ForwardButton
		onClicked: event => {
			switch (event.button) {
				case Qt.LeftButton:
					Niri.toggleOverview();
					break;
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

		RowLayout {
			anchors.fill: parent
			id: content
			width: Math.min(root.width, 1920)

			spacing: 0
			WindowListWidget {screen: root.screen.name}
			Item { width: 26; }
			DesktopMenuWidget {}
			WindowActionWidget {}
			Item{Layout.fillWidth: true; Layout.horizontalStretchFactor: 1}
			Loader {
				Layout.fillWidth: true
				active: root.screen.name == "eDP-1"
				sourceComponent: RoundButton {
					icon.name: "input-keyboard-virtual-show"
					icon.color: Material.color(Material.Purple, Material.Shade200)
					flat: true
					onClicked: Niri.spawn(["qs", "-p", "/etc/nixos/programs/qs-keyboard/shell.qml", "ipc", "call", "root", "toggle"]);
				}
			}
			Loader {
				Layout.fillWidth: true
				active: root.screen.name != "eDP-1"
				sourceComponent: QuodlibetMenuWidget {}
			}
			// Separator {inset: 0}
			TlpWidget {}
			MenuWithButton {
				id: settingsMenu
				icon.name: "settings-configure"
				content: ColumnLayout {
					Material.theme: Material.Dark
					Material.accent: Material.Green
					spacing: 16
					BluetoothWidget {}
					RowLayout {
						InputPlumberWidget {}
						Item{Layout.fillWidth: true; Layout.horizontalStretchFactor: 1}
						KeyboardLayoutWidget {}
					}
					BluelightWidget {}
					BrightnessWidget {}
					VolumeWidget {}
					// Separator { vertical: true }
				}
			}
			MenuWithButton {
				Layout.rightMargin: (52 - implicitHeight) / 2
				square: false
				leftPadding: 10
				rightPadding: 10
				topPadding: 10
				bottomPadding: 10
				contentItem: ClockWidget {height: 24; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter}
				content: CalendarWidget {}
			}
		}
	}
}
