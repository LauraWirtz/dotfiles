// ClockWidget.qml
import QtQuick
import "../items"
import "../services"

MenuWithButton {
	id: root
	icon.name: "library-music-symbolic"
	text: QuodlibetService.current.title ?? "Not Playing"
	square: false

	content: QuodlibetWidget {
		active: root.active
	}
}
