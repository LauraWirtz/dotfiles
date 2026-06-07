// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import "./items"

import QtQuick.Controls.Basic


PanelWindow {
	id:root
	color: "transparent"
	property var screen: Quickshell.screens[0]

	anchors.left: true
	anchors.top: true

	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "qs-keyboard"

	// mask: Region { item: keeb; }
	implicitWidth: keeb.width
	implicitHeight: keeb.height

	property real x
	property real y

	margins.left: KeyboardService.visible ? x : -keeb.width
	margins.top: KeyboardService.visible ? y : -keeb.height

	KeyboardWidget {
		id: keeb

		opacity: dragHandler.active ? 0.5 : 1
	}

	KeyboardButton {
		id: handle
		x: 14 * KeyboardService.scale + 1 * KeyboardService.padding
		y: 1 * KeyboardService.padding
		width: KeyboardService.scale - KeyboardService.padding
		height: KeyboardService.scale - KeyboardService.padding

		icon.name: "drag-surface"
        icon.color: "white"
		icon.width: 32
		icon.height: 32

		state: dragHandler.active ? "ACTIVE" : ""

		DragHandler {
			id: dragHandler

			target: null
			dragThreshold: 4

			onPersistentTranslationChanged: {
				if(persistentTranslation.x < 0) {persistentTranslation.x = 0;}
				if(persistentTranslation.x > root.screen.width - keeb.width) {persistentTranslation.x = root.screen.width - keeb.width;}
				if(persistentTranslation.y < 0) {persistentTranslation.y = 0;}
				if(persistentTranslation.y > root.screen.height - keeb.height) {persistentTranslation.y = root.screen.height - keeb.height;}

				root.x = persistentTranslation.x
				root.y = persistentTranslation.y
			}

			Component.onCompleted: {
				persistentTranslation.x = screen.width / 2 - keeb.width / 2
				persistentTranslation.y = screen.height - keeb.height - 56 - 2*10
			}
		}
	}
}
