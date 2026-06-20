// ClockWidget.qml
import QtQuick
import "../items"
import "../services"

MenuWithButton {
	id: root
	icon.name: "library-music-symbolic"
	text: QuodlibetService.current.title ? QuodlibetService.current.title.length > 24 ? QuodlibetService.current.title.slice(0, 20)+"…" : QuodlibetService.current.title : "Not Playing"
	square: false

	content: QuodlibetWidget {
		active: root.active
	}
}
