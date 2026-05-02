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
		// Layout.fillWidth: true
		// implicitWidth: 500

		uniformCellWidths: true
		uniformCellHeights: true
		columnSpacing: 12
		rowSpacing: 12
		columns: 7

		Repeater {
			model: CalendarService.dateArray
			Text{
				Layout.fillWidth: true
				text: modelData.getDate()
				// font.pixelSize: 16
				color: modelData.getMonth() == CalendarService.now.getMonth() ? (modelData.getDate() == CalendarService.now.getDate() ? "red" : "white") : "grey"
				horizontalAlignment: Text.AlignHCenter
			}
		}
	}
}
