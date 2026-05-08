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

	anchors.bottom: true
	margins.bottom: -5
	implicitWidth: 1260
	implicitHeight: 52

	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Top
	WlrLayershell.namespace: "qs-taskbar"

	Rectangle {
		id: overviewShape

		anchors.fill: parent
		radius: 26
		// opacity: 0.9

		gradient: Gradient {
			GradientStop { position: 0.0; color: Qt.lighter("#292c30", 1.5) }
			GradientStop { position: 1.0; color: Qt.darker("#292c30", 1.5)  }
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
		RowLayout {
			anchors.fill: parent
			id: content

			Material.theme: Material.Dark
			Material.accent: Material.Blue

			spacing: 0
			Item{
				width: 80 + 13
			}
			WindowListWidget {screen: root.screen.name}
			MenuWithButton {
				icon.name: "list-add"
				margin: 16

				content: RowLayout {
					spacing: 0
					DesktopWidget {
						model: DesktopService.getFilteredEntries(true, [
							"floorp",
							"org.kde.dolphin",
							"org.kde.kate",
							"foot",
						])
						orientation: ListView.Vertical
						display: AbstractButton.IconOnly
						interactive: false
						size: 64
						spacing: -8
					}
					DesktopWidget {
						Layout.fillHeight: true
						model: DesktopService.getFilteredEntries(false, [
							"floorp",
							"org.kde.dolphin",
							"org.kde.kate",
							"foot",
						])
						orientation: ListView.Vertical
						interactive: false
						spacing: -10
					}
				}

			}
			Item {
				Layout.fillWidth: true
				Layout.horizontalStretchFactor: 1
			}
			MenuWithButton {
				icon.name: "settings-configure"
				flat: true
				margin: 16
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
					QuodlibetWidget {}
				}
			}
			TlpWidget {}
			MenuWithButton {
				Layout.rightMargin: 13
				flat: true
				margin: 16
				text: Time.date
				content: CalendarWidget {}
			}
		}
	}
}
