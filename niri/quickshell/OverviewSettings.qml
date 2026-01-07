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

import QtQuick.Controls.Basic

PanelWindow {
	id: root
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
				PropertyChanges {window.y: 40}
			},
			State {
				name: "NOVERVIEW"
				when: !Niri.inOverview
				StateChangeScript { script: view.currentIndex = 0 }
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
					Layout.topMargin: 16
					Layout.leftMargin: 0
					spacing: 0
					TabBarButton {
						name: "configure"
						icon_width: 32
						icon_height: 32
						show: view.currentIndex == 0
						onClicked: view.setCurrentIndex(0)
					}
					TabBarButton {
						name: "applications-system-symbolic"
						icon_width: 32
						icon_height: 32
						show: view.currentIndex == 1
						onClicked: view.currentIndex == 1 ? view.setCurrentIndex(0) : view.setCurrentIndex(1)
					}
					TabBarButton {
						name: "network-bluetooth"
						icon_width: 32
						icon_height: 32
						show: view.currentIndex == 2
						onClicked: view.currentIndex == 2 ? view.setCurrentIndex(0) : view.setCurrentIndex(2)
					}
					TabBarButton {
						name: "window-new-symbolic"
						icon_width: 32
						icon_height: 32
						show: view.currentIndex == 3
						onClicked: view.currentIndex == 3 ? view.setCurrentIndex(0) : view.setCurrentIndex(3)
					}
				}
				MouseArea {
					Layout.fillWidth: true
					Layout.fillHeight: true
					onClicked: view.setCurrentIndex(0)
				}
				WindowActionWidget {
					Layout.alignment: Qt.AlignRight

				}
			}
			Rectangle {
				Layout.fillWidth: true
				Layout.preferredWidth: view.contentChildren.reduce((acc, el) => {
					return Math.max(acc, el.implicitWidth)
				}, 0) + 32
				Layout.preferredHeight: view.implicitContentHeight + 32
				color: "#202326"
				radius: 8
				topLeftRadius: view.currentIndex == 0 ? 0 : 8


				SwipeView {
					id: view
					clip: true
					anchors.fill: parent
					anchors.margins: 16

					RowLayout {
						spacing: 16
						BrightnessWidget {}
						VolumeWidget {}
					}
					ColumnLayout {
						spacing: 16
						RowLayout {
							spacing: 16
							KeyboardLayoutWidget {}
							InputPlumberWidget {}
						}
						PlayerWidget {}
					}
					BluetoothWidget {}
					ColumnLayout {
						Layout.fillWidth: true
						spacing: 16
						DesktopWidget {
							Layout.fillWidth: true
							model: [
								DesktopService.byId("net.kuribo64.melonDS"),
								DesktopService.byId("org.azahar_emu.Azahar"),
								DesktopService.byId("dolphin-emu"),
								DesktopService.byId("info.cemu.Cemu"),
								DesktopService.byId("Ryujinx"),
							]
							columns: 5
							alignment: Qt.AlignHCenter
							display: AbstractButton.IconOnly
							interactive: false
							size: 64
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
							columns: 3
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
