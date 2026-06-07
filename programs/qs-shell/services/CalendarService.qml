// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
	id: root

	readonly property var now: new Date(Date.now())
	property var dateArray: []

	Component.onCompleted: {
		let tempDateArray = []
		let elDate = new Date(now)
		elDate.setDate(1)
		let weekDay = elDate.getDay()
		weekDay = weekDay == 0 ? 7 : weekDay
		weekDay = weekDay == 1 ? 8 : weekDay
		elDate.setDate(elDate.getDate() - weekDay + 1)

		while(elDate.getMonth() <= now.getMonth() || elDate.getDay() != 1) {
			tempDateArray.push(new Date(elDate))
			elDate.setDate(elDate.getDate() + 1)
		}

		if( tempDateArray[tempDateArray.length-1].getMonth() == now.getMonth() ) {
			for (let i = 0; i < 7; i++) {
				tempDateArray.push(new Date(elDate))
				elDate.setDate(elDate.getDate() + 1)
			}
		}
		dateArray = tempDateArray
	}
}
