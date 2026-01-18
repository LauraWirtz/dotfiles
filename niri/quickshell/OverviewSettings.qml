// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import "./services"
import "./widgets"
import "./items"

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

	mask: Region { item: window }


	Rectangle {
		Material.theme: Material.Dark
		Material.accent: Material.Pink
		id: window
		anchors.horizontalCenter: parent.horizontalCenter
		implicitWidth: children[0].implicitWidth
		implicitHeight: children[0].implicitHeight
		radius: 8
		color: "#292c30"

		y: -height - 10

		states: [
			State {
				name: "OVERVIEW"
				when: Niri.inOverview
				PropertyChanges {window.y: 0.25 * root.height}
			},
			State {
				name: "NOVERVIEW"
				when: !Niri.inOverview
				StateChangeScript { script: view.currentIndex = -1 }
			}
		]
		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 150 }
		}

		ColumnLayout {
			// anchors.fill: parent
			// anchors.margins: 16
			spacing: 0
			RowLayout {
				Layout.fillWidth: true
				Layout.topMargin: 0
				Layout.bottomMargin: 0
				// Layout.leftMargin: 16
				Layout.rightMargin: 16
				id: defaultItems
				spacing: 0
				RowLayout {
					spacing: 0
					Button {
						icon.name: "applications-system-symbolic"
						icon.width: 32
						icon.height: 32
						flat: true
						checkable: true
						checked: view.currentIndex == 0
						onClicked: view.currentIndex == 0 ? view.setCurrentIndex(-1) : view.setCurrentIndex(0)
					}
					Button {
						icon.name: "network-bluetooth"
						icon.width: 32
						icon.height: 32
						flat: true
						checkable: true
						checked: view.currentIndex == 1
						onClicked: view.currentIndex == 1 ? view.setCurrentIndex(-1) : view.setCurrentIndex(1)
					}
					Button {
						icon.name: "window-new-symbolic"
						icon.width: 32
						icon.height: 32
						flat: true
						checkable: true
						checked: view.currentIndex == 2
						onClicked: view.currentIndex == 2 ? view.setCurrentIndex(-1) : view.setCurrentIndex(2)
					}
				}
				MouseArea {
					Layout.fillWidth: true
					Layout.fillHeight: true
					onClicked: view.setCurrentIndex(-1)
				}
				WindowActionWidget {}
			}
			Rectangle {
				Layout.fillWidth: true
				Layout.preferredWidth: view.contentChildren.reduce((acc, el) => {
					return Math.max(acc, el.implicitWidth)
				}, 0) + 32
				Layout.preferredHeight: view.currentIndex == -1 ? 0 : view.implicitContentHeight + 32
				color: "#202326"
				radius: 8
				topLeftRadius: view.currentIndex == 0 ? 0 : 8

				SwipeView {
					id: view
					clip: true
					anchors.fill: parent
					anchors.margins: 16

					ColumnLayout {
						spacing: 16
						VolumeWidget {}
						BrightnessWidget {}
						BluelightWidget {}
						RowLayout {
							spacing: 16
							KeyboardLayoutWidget {}
							InputPlumberWidget { Layout.fillWidth: false }
						}
						TlpWidget {}
						PlayerWidget {}
					}
					BluetoothWidget {}
					RowLayout {
						Layout.fillWidth: true
						spacing: 16
						Loader {
							// Layout.fillWidth: true
							active: false
							sourceComponent: Component {
								DesktopWidget {
									model: [
										DesktopService.byId("net.kuribo64.melonDS"),
										DesktopService.byId("org.azahar_emu.Azahar"),
										DesktopService.byId("dolphin-emu"),
										DesktopService.byId("info.cemu.Cemu"),
										DesktopService.byId("Ryujinx"),
									]
									alignment: Qt.AlignHCenter
									display: AbstractButton.IconOnly
									interactive: false
									size: 64
								}
							}
							Timer {
								interval: 3000; running: true; repeat: false
								onTriggered: parent.active = true
							}
						}
						DesktopWidget {
							Layout.fillWidth: true
							model: DesktopService.getFilteredEntries([
								"net.kuribo64.melonDS",
								"org.azahar_emu.Azahar",
								"dolphin-emu",
								"info.cemu.Cemu",
								"Ryujinx",
							])
						}
					}
				}
			}
		}
		RectangularShadow {
			anchors.fill: parent
			z: -1
			blur: 15
			spread: 0
			radius: 8
		}
	}
}
