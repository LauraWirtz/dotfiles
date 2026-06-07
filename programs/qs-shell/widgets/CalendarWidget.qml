// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import "../services"

import QtQuick.Controls.Material

ColumnLayout {
	Layout.fillWidth: false
	RowLayout {
		Layout.fillWidth: true
		uniformCellSizes: true
		spacing: 0
		Repeater {
			model: [ "Mo", "Di", "Mi", "Do", "Fr", "Sa", "So"]

			Text {
				Layout.fillWidth: true
				text: modelData
				color: "white"
				horizontalAlignment: Text.AlignHCenter
			}
		}
	}

	GridLayout {
		uniformCellWidths: true
		uniformCellHeights: true
		columnSpacing: 0
		rowSpacing: 0
		columns: 7

		Repeater {
			model: CalendarService.dateArray
			Rectangle {
				id: background
				implicitWidth: Math.max(text.implicitWidth, text.implicitHeight) + 8
				implicitHeight: implicitWidth
				radius: 8

				color: "transparent"
				border.width: 2
				border.color: modelData.getMonth() == CalendarService.now.getMonth() && modelData.getDate() == CalendarService.now.getDate() ? Material.color(Material.Green, Material.Shade200) : "transparent"
				Text{
					id: text
					anchors.centerIn: background

					text: modelData.getDate()
					font.pixelSize: 16
					color: modelData.getMonth() == CalendarService.now.getMonth() ? (modelData.getDate() == CalendarService.now.getDate() ? Material.color(Material.Green, Material.Shade200) : "#bbffffff") : "#44ffffff"
				}
			}
		}
	}
}
