// Bar.qml
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
Scope {
	PanelWindow {
		id:doot
		visible: true
		color: "transparent"

		anchors {
			bottom: true
			left: true
			right: true
		}
		WlrLayershell.layer: WlrLayer.Top

		implicitHeight: 40
	}

	PanelWindow {
		id:root
		color: "transparent"

		anchors {
			top: true
			bottom: true
			left: true
			right: true
		}
		exclusionMode: ExclusionMode.Ignore
		WlrLayershell.layer: WlrLayer.Overlay

		mask: Region { x:0; y: keeb.y; width: root.width; height: keeb.height; }

		KeyboardWidget {
			id: keeb

			anchors.left: parent.left
			anchors.bottom: parent.bottom
			anchors.leftMargin: 20
			anchors.bottomMargin: -height

			visible: false

			states: [
				State {
					name: "VISIBLE"
					when: KeyboardService.visible
					PropertyChanges {keeb.anchors.bottomMargin: 20}
					PropertyChanges {keeb.visible: true}
					PropertyChanges {touchpad.visible: true}
					PropertyChanges {doot.implicitHeight: keeb.height + 40}
				}
			]
			transitions: [
				Transition {
					to: "VISIBLE"
					SequentialAnimation{
						PropertyAction { target: keeb; property: "visible"; value: true }
						NumberAnimation { properties: "keeb.anchors.bottomMargin"; easing.type: Easing.OutQuad; duration: 100 }
						PropertyAction { target: doot; property: "implicitHeight"; value: keeb.height }

					}
				},
				Transition {
					from: "VISIBLE"; to: "*"
					SequentialAnimation{
						NumberAnimation { properties: "keeb.anchors.bottomMargin"; easing.type: Easing.InQuad; duration: 100 }
						PropertyAction { target: keeb; property: "visible"; value: false }
						// PauseAnimation { duration: 100}
						PropertyAction { target: doot; property: "implicitHeight"; value: 0 }
					}
				},
			]

			ArrowKeyWidget {
				x: 12.75 * KeyboardService.scale + 2 * KeyboardService.padding
				y: 4 * KeyboardService.scale + 2 * KeyboardService.padding
			}
		}
		Rectangle {
			id: touchpad
			anchors.top: keeb.top
			anchors.right: parent.right
			anchors.rightMargin: 20

			width: childrenRect.width + 2*KeyboardService.padding
			height: childrenRect.height + 2* KeyboardService.padding

			radius: KeyboardService.rounding + 2*KeyboardService.padding
			color: "#202326"

			MouseMoveWidget {
				id:toucharea
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.margins: 2*KeyboardService.padding
			}
			MouseButtonWidget {
				id: leftclick
				anchors.top: toucharea.bottom
				anchors.left: toucharea.left
				anchors.topMargin: 2*KeyboardService.padding
				click: "0"
			}
			MouseButtonWidget {
				id: rightclick
				anchors.top: toucharea.bottom
				anchors.right: toucharea.right
				anchors.topMargin: 2*KeyboardService.padding
				click: "1"
			}

			RectangularShadow {
				id: shadow
				anchors.fill: parent
				z: -1
				blur: 15
				spread: 0
				radius: parent.radius
			}
		}
	}
}
