// Bar.qml
import Quickshell
import Quickshell.Wayland
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

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Top

	mask: Region { item: mouseArea; }

	RectangularShadow {
		id: overviewShadow
		anchors.fill: mouseArea
		color: "#88000000"
		blur: 5
		spread: 5
		radius: overviewShape.radius
		offset.x: 0
		offset.y: 0
	}

	MouseArea {
		id: mouseArea

		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: -5
		width: content.implicitWidth
		height: lowerContent.implicitHeight

		clip: true

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
				default:
					mouseArea.extended = !mouseArea.extended
			}
		}
		onWheel: event => {
			if(event.angleDelta.y > 0) { Niri.focusColumnLeft() }
			else { Niri.focusColumnRight() }
		}
		onExited: event => {
			mouseArea.extended = false
		}

		property bool extended: false

		states: [
			State {
				name: "EXTENDED"
				when: mouseArea.extended
				extend: "OVERVIEW"
				PropertyChanges {mouseArea.height: content.implicitHeight}
				PropertyChanges {overviewShape.upperColor: Qt.lighter("#292c30", 1.25)}
				PropertyChanges {overviewShape.lowerColor: Qt.darker("#292c30", 1.25)}

			},
		]

		Behavior on height { NumberAnimation { easing.type: Easing.OutQuad; duration: 150 } }

		DragHandler {
			acceptedDevices: PointerDevice.TouchScreen

			readonly property real interval: 50
			property int currentCount: 0

			target: null
			xAxis.onActiveValueChanged: delta => {
				var newCount = Math.round(xAxis.activeValue / interval)
				if(newCount < currentCount) {
					Niri.focusColumnRight()
				} else if(newCount > currentCount) {
					Niri.focusColumnLeft()
				}
				currentCount = newCount
			}
			onActiveChanged: currentCount = 0
		}
		Rectangle {
			Material.theme: Material.Dark
			Material.accent: Material.Blue
			id: overviewShape

			anchors.fill: parent
			radius: 26

			property color upperColor: Qt.lighter("#292c30", 1.5)
			property color lowerColor: Qt.darker("#292c30", 1.5)

			gradient: Gradient {
				GradientStop { position: 0.0; color: overviewShape.upperColor }
				GradientStop { position: 1.0; color: overviewShape.lowerColor }
			}

			Behavior on upperColor { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }
			Behavior on lowerColor { ColorAnimation { easing.type: Easing.OutQuad; duration: 150 } }

			ColumnLayout {
				id: content
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				spacing: 0

				RowLayout {
					id: upperContent
					Layout.margins: 16
					spacing: 16
					Loader {
						active: false
						sourceComponent: Component {
							DesktopWidget {
								model: [
									DesktopService.byId("floorp"),
									DesktopService.byId("org.kde.dolphin"),
									DesktopService.byId("org.kde.kate"),
									DesktopService.byId("foot"),
								]
								orientation: ListView.Vertical
								display: AbstractButton.IconOnly
								interactive: false
								size: 64
								spacing: -8
							}
						}
						Timer {
							interval: 3000; running: true; repeat: false
							onTriggered: parent.active = true
						}
					}
					DesktopWidget {
						Layout.fillWidth: true
						Layout.fillHeight: true
						model: DesktopService.getFilteredEntries([
							"floorp",
							"org.kde.dolphin",
							"org.kde.kate",
							"foot",
						])
						orientation: ListView.Vertical
						interactive: false
						spacing: -10
					}
					Separator {}
					ColumnLayout {
						Layout.fillWidth: true
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
				RowLayout {
					id: lowerContent
					spacing: 0
					Item {
						Layout.fillWidth: true
						Layout.horizontalStretchFactor: 1
					}
					TlpWidget {}
					Separator {}
					WindowActionWidget {}
				}
			}
		}
	}
}
