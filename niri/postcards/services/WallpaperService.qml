import Quickshell
import Quickshell.Io
import QtQuick

Item {
	id: root

	property bool initialized: false

	required property int monitorWidth		// monitor width
	required property int monitorHeight		// monitor height

	property int border: 0					// clear space around monitor edge (can be negative)

	required property string source
	property int size: 400					// postcard size
	property int count: 20					// # of postcards
	property int maxRotation: 30			// maximum degree of rotation
	property int interval: 60000			// interval of new postcards

	property int nextRemoval: 0
	property bool removalState: true
	property int currentZ: 0

	property var paths: []

	property ListModel images: ListModel {

		function every(callback): bool {
			let success = true

			for (let i = 0; i < this.count; i++) {
				const el = root.images.get(i)
				if(!callback(el)) { success = false }
			}
			return success
		}
	}

	Timer {
		interval: root.interval/2; running: root.initialized; repeat: true
		onTriggered: {
			if(removalState) {
				root.images.setProperty(nextRemoval, "source", "")
			} else {
				root.replenish()

				root.nextRemoval++
				if(root.nextRemoval == root.images.count) {root.nextRemoval = 0}
			}
			root.removalState = !root.removalState
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
	Timer {
		id: rescan
		interval: 3600000; running: true; repeat: true
		onTriggered: {
			pathfinder.running = true
		}
	}

	Process {
		id: pathfinder
		running: true
		command: [ "find", root.source, "f" ]
		stdout: SplitParser { onRead: data => {
			if(root.paths.every(el => {
				return el.url != data
			})) {
				root.paths.push(data)
			}
			initialRun.restart()
		} }
	}

	function populate(): void {
		for (let i = 0; i < root.count; i++) {
			root.images.append(next())
		}
	}

	function replenish(): void {
		root.images.set(nextRemoval, next())
	}

	function next(): var {
		let candidate = ""
		while(
			!(candidate.includes(".png") || candidate.includes(".jpg") || candidate.includes(".jpeg")) ||
			!root.images.every(el => { return el.source != candidate })
		) {
			candidate = root.paths[Math.floor(Math.random() * root.paths.length)]
		}
		const coords = generateCoordinates()
		const rotation = root.maxRotation * Math.random() - 0.5 * root.maxRotation
		root.currentZ++
		return { "source": candidate, "posX": coords.x, "posY": coords.y, "posZ": root.currentZ, "rotation": rotation }
	}

	function generateCoordinates(): var {
		let attempts = []
		while(attempts.length < 10*(root.images.count+1)) {
			let x = (root.monitorWidth - 2.0 * root.border - root.size) * Math.random() + root.border
			let y = (root.monitorHeight - 2.0 * root.border - root.size) * Math.random() + root.border

			let summedDistance = 0
			for (let i = 0; i < root.images.count; i++) {
				const el = root.images.get(i)
				let distance = Math.sqrt(Math.pow(x - el.posX, 2.0), Math.pow(y - el.posY, 2.0))
				const upperLimit = 1.5 * root.size
				distance = distance > upperLimit ? upperLimit : distance
				summedDistance += Math.pow(distance, 0.25)
			}
			attempts.push({x: x, y: y, summedDistance: summedDistance})
		}
		let best = attempts.reduce((best, el) => {
			return el.summedDistance > best.summedDistance ? el : best
		})
		return best
	}
}
