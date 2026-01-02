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
	color: "transparent"

	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Top

	mask: Region { item: flick.contentItem }

	Flickable {
		id: flick
		anchors.horizontalCenter: parent.horizontalCenter
		implicitWidth: contentWidth
		implicitHeight: root.height
		contentWidth: contentItem.children[0].implicitWidth
		contentHeight: contentItem.children[0].implicitHeight
		topMargin: 40
		bottomMargin: 0.75 * root.height + 10
		y: -0.25 * root.height

		onVerticalOvershootChanged: if(flick.verticalOvershoot>20 && !flick.flicking) Niri.closeOverview()

		states: [
			State {
				name: "OVERVIEW"
				when: Niri.inOverview
				PropertyChanges {flick.y: 0}
				StateChangeScript { script: !flick.atYEnd ? flick.flick(0, -flick.maximumFlickVelocity) : flick.flick(0, -50) }
			},
			State {
				name: "NOVERVIEW"
				when: !Niri.inOverview
				StateChangeScript { script: !flick.atYEnd ? flick.flick(0, -flick.maximumFlickVelocity) : flick.flick(0, -50) }
			}
		]
		transitions: Transition {
			NumberAnimation { properties: "y"; easing.type: Easing.InOutQuad; duration: 150 }
		}

		// boundsBehavior: Flickable.StopAtBounds

		Rectangle {
			id: window
			implicitWidth: children[0].implicitWidth+32
			implicitHeight: children[0].implicitHeight+32
			radius: 8
			color: "#292c30"
			ColumnLayout {
				anchors.fill: parent
				anchors.margins: 16
				spacing: 16
				BluetoothWidget {}
				DesktopWidget {}
				ColumnLayout {
					id: defaultItems
					spacing: 16
					RowLayout {
						spacing: 16
						KeyboardLayoutWidget {}
						InputPlumberWidget {}
					}
					PlayerWidget {}
					RowLayout {
						spacing: 16
						BrightnessWidget {}
						VolumeWidget {}
					}
					WindowActionWidget { Layout.alignment: Qt.AlignHCenter }
				}
			}
			RectangularShadow {
				anchors.fill: parent
				z: -1
				blur: 15
				spread: 0
				radius: 8
				cached: true
			}
		}
	}
}
