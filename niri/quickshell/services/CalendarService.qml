// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: root

	readonly property var now: new Date(Date.now())
	property var dateArray: []

	Component.onCompleted: {
		// const now = new Date(Date.now())
		// now.setMonth(now.getMonth() -1)

		let elDate = new Date(now)
		let weekDay = elDate.getDay()
		weekDay = weekDay == 0 ? 7 : weekDay
		elDate.setDate(elDate.getDate() - weekDay + 1)

		while(elDate.getMonth() <= now.getMonth() || elDate.getDay() != 1) {
			dateArray.push(new Date(elDate))
			elDate.setDate(elDate.getDate() + 1)
		}

		if( dateArray[dateArray.length-1].getMonth() == now.getMonth() ) {
			for (let i = 0; i < 7; i++) {
				dateArray.push(new Date(elDate))
				elDate.setDate(elDate.getDate() + 1)
			}
		}
		console.log(dateArray)
	}
}
