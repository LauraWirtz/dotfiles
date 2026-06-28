// ClockWidget.qml
import QtQuick
import "../items"
import "../services"

MenuWithButton {
	id: root
	icon.name: "library-music-symbolic"
	text: QuodlibetService.hasCurrent ? QuodlibetService.current.title ?? "Not Playing" : "Not Playing"
	square: false
	implicitWidth: 200

	content: QuodlibetWidget {
		active: root.active
	}
}
