// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../services"

import QtQuick.Controls.Material

ColumnLayout {
	spacing: 16

	Text {
		id: heading
		Layout.alignment: Qt.AlignHCenter
		text: Time.date
		color: "white"
		font.pixelSize: 20

		onTextChanged: {
			calendarLoader.active = false
			calendarLoader.active = true
		}
	}

	Loader {
		id: calendarLoader
		sourceComponent: GridLayout {
			columns: 2

			DayOfWeekRow {
				locale: grid.locale
				spacing: grid.spacing

				Layout.column: 1
				Layout.fillWidth: true

				delegate: Text {
					required property var model

					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					color: "white"

					text: model.shortName
				}
			}

			WeekNumberColumn {
				month: grid.month
				year: grid.year
				locale: grid.locale
				spacing: grid.spacing

				Layout.fillHeight: true

				delegate: Text {
					required property var model

					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: Text.AlignVCenter
					color: "white"

					text: model.weekNumber
				}
			}

			MonthGrid {
				id: grid
				// month: Calendar.December
				// year: 2015
				locale: Qt.locale("de_DE")

				Layout.fillWidth: true
				Layout.fillHeight: true
				spacing: 0

				delegate: Rectangle {
					id: background
					implicitWidth: Math.max(text.implicitWidth, text.implicitHeight) + 8
					implicitHeight: implicitWidth
					radius: 5

					color: "transparent"
					border.width: 2
					border.color: model.today ? Material.color(Material.Green, Material.Shade200) : "transparent"
					Text{
						id: text
						anchors.centerIn: background

						text: model.day
						font.pixelSize: 16
						opacity: model.month === grid.month ? 1 : 0.5
						color: model.today ? Material.color(Material.Green, Material.Shade200) : "white"
					}
				}
			}
		}
	}
}
