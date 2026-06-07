// Bar.qml
import Quickshell
import Quickshell.Wayland
import QtQuick
import "./items"


PanelWindow {
	id:root
	color: "transparent"
	property var screen: Quickshell.screens[0]

	anchors.left: true
	anchors.top: true

	exclusionMode: ExclusionMode.Ignore
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.namespace: "qs-keyboard"

	implicitWidth: keeb.width
	implicitHeight: keeb.height

	visible: KeyboardService.visible

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
				root.margins.left = Math.min(Math.max(persistentTranslation.x, 0), root.screen.width - keeb.width)
				root.margins.top = Math.min(Math.max(persistentTranslation.y, 0), root.screen.height - keeb.height)
			}

			Component.onCompleted: {
				persistentTranslation.x = screen.width / 2 - keeb.width / 2
				persistentTranslation.y = screen.height - keeb.height - 56 - 2*10
			}
		}
	}
}
