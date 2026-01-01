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
		contentWidth: contentItem.childrenRect.width
		contentHeight: contentItem.childrenRect.height
		topMargin: 40
		bottomMargin: root.height - defaultItems.height - 16
		maximumFlickVelocity: 6000
		y: -defaultItems.height - 16 -10

		states: [
			State {
				name: "OVERVIEW"
				when: Niri.inOverview
				PropertyChanges {flick.y: 0}
				StateChangeScript { script: !flick.atYEnd ? flick.flick(0, -6000) : flick.flick(0, -50) }
			},
			State {
				name: "NOVERVIEW"
				when: !Niri.inOverview
				StateChangeScript { script: !flick.atYEnd ? flick.flick(0, -6000) : flick.flick(0, -50) }
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
			radius: 5
			color: "#292c30"
			ColumnLayout {
				anchors.fill: parent
				anchors.margins: 16
				spacing: 16
				BluetoothWidget {}
				DesktopWidget {}
				ColumnLayout {
					id: defaultItems
					KeyboardLayoutWidget {}
					InputPlumberWidget {}
					RowLayout {
						BrightnessWidget {}
						VolumeWidget {}
					}
					PlayerWidget {}

				}
			}
			RectangularShadow {
				anchors.fill: parent
				z: -1
				blur: 15
				spread: 0
				radius: 5
			}
		}
	}
}
