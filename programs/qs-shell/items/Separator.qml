import QtQuick
import QtQuick.Layouts

Rectangle {
	property bool vertical: false
	property real inset: 0

	width: 2
	height: 2
	radius: 1
	color: "#22ffffff"

	Layout.fillHeight: !vertical
	Layout.leftMargin: vertical ? 8 : -inset
	Layout.rightMargin: vertical ? 8 : -inset
	Layout.topMargin: vertical ? -inset : 8
	Layout.bottomMargin: vertical ? -inset : 8

	Layout.fillWidth: vertical

}
