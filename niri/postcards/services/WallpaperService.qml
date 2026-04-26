import Quickshell
import Quickshell.Io
import QtQuick

Item {
	id: root

	property bool initialized: false

	required property int monitorWidth				// monitor width
	required property int monitorHeight				// monitor height

	property int border: 0					// clear space around monitor edge (can be negative)
	// property int distance: 200


	required property string source
	property int size: 400					// postcard size
	property int count: 20					// # of postcards
	property int maxRotation: 30			// maximum degree of rotation
	property int interval: 60000			// interval of new postcards

	property int nextRemoval: 0
	property string removalState: "none"
	property int currentZ: 0

	property var paths: []
	property var images: []

	Timer {
		interval: root.interval/4; running: root.initialized; repeat: true
		onTriggered: {
			if(removalState == "none") {
				root.removalState = "hide"
			} else if(removalState == "hide") {
				root.replenish()
				root.removalState = "update"
			} else if(removalState == "update") {
				root.removalState = "reveal"
			} else if(removalState == "reveal") {
				root.nextRemoval++
				if(root.nextRemoval == root.images.length) {root.nextRemoval = 0}
				root.removalState = "none"
			}
		}
	}
	Timer {
		id: initialRun
		interval: 100; running: true; repeat: false
		onTriggered: {
			root.populate()
			root.initialized = true
		}
	}

	Process {
		id: pathfinder
		running: true
		command: [ "find", root.source, "f" ]
		stdout: SplitParser { onRead: data => {
			root.paths.push(data)
			initialRun.restart()
		} }
	}

	function populate(): void {
		for (let i = 0; i < root.count; i++) {
			root.images.push(next())
		}
	}

	function replenish(): void {
		const newEl = next()
		root.images[root.nextRemoval]= newEl

	}

	function next(): var {
		var candidate = ""
		while(
			!candidate.includes(".png") &&
			!candidate.includes(".jpg") &&
			!candidate.includes(".jpeg") &&
			root.images.every(el => { return el.url != candidate })
		) {
			candidate = root.paths[Math.floor(Math.random() * root.paths.length)]
		}
		const coords = generateCoordinates()
		const rotation = root.maxRotation * Math.random() - 0.5 * root.maxRotation
		root.currentZ++
		return { url: candidate, x: coords.x, y: coords.y, rotation: rotation, z: root.currentZ }
	}

	function generateCoordinates(): var {
		var attempts = []
		while(attempts.length < 10*(root.images.length+1)) {
			var x = (root.monitorWidth - 2.0 * root.border - root.size) * Math.random() + root.border
			var y = (root.monitorHeight - 2.0 * root.border - root.size) * Math.random() + root.border

			var summedDistance = root.images.reduce((sum, el) => {
				var distance = Math.sqrt(Math.pow(x - el.x, 2.0), Math.pow(y - el.y, 2.0))

				const lowerLimit = 0.5 * root.size
				const upperLimit = 2 * root.size
				const lowerPunishment = -2 * root.size

				distance = distance < lowerLimit ? lowerPunishment : distance
				distance = distance > upperLimit ? upperLimit : distance
				return sum + distance
			}, 0)
			attempts.push({x: x, y: y, summedDistance: summedDistance})
		}
		var best = attempts.reduce((best, el) => {
			return el.summedDistance > best.summedDistance ? el : best
		})
		return best
	}
}
