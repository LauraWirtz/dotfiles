import Quickshell
import Quickshell.Io
import QtQuick

Item {
	id: root

	component Borders: QtObject {
		property int top: -9999
		property int bottom: -9999
		property int left: -9999
		property int right: -9999
	}

	required property int monitorWidth		// monitor width
	required property int monitorHeight		// monitor height

	property int border: 0					// clear space around monitor edge (can be negative)
	property Borders borders: Borders {}
	property Borders bounds: Borders {}

	required property string source
	property int size: 400					// postcard size
	property int count: 20					// # of postcards
	property int maxRotation: 30			// maximum degree of rotation
	property int interval: 60000			// interval of new postcards

	property int nextRemoval: 0
	property bool removalState: true
	property int currentZ: 0

	// property int stepCount: 10000
	property real stepSize: 1

	property var paths: []

	property ListModel images: ListModel {

		function every(callback): bool {
			let success = true

			for (let i = 0; i < this.count; i++) {
				const el = this.get(i)
				if(!callback(el)) { success = false }
			}
			return success
		}
		function reduce(callback, initialValue) {
			const hasInit = initialValue != null
			let accumulator = hasInit ? initialValue : this.get(0)

			for (let i = hasInit ? 0 : 1; i < this.count; i++) {
				const currentValue = this.get(i)
				accumulator = callback(accumulator, currentValue, i , this)
			}
			return accumulator
		}
	}

	Timer {
		id: cardUpdater
		interval: root.interval/2; running: false; repeat: true
		onTriggered: {
			if(removalState) {
				root.images.setProperty(nextRemoval, "url", "")
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
			cardUpdater.running = true
		}
	}

	Process {
		id: pathfinder
		running: true
		command: [ "find", root.source, "-type", "f" ]
		stdout: SplitParser { onRead: data => {
			if(root.paths.every(el => {
				return el != data
			})) {
				root.paths.push(data)
			}
			initialRun.restart()
		} }
	}

	function populate(): void {
		root.bounds.top = 0.5 * root.size + (root.borders.top != -9999 ? root.borders.top : root.border)
		root.bounds.bottom = root.monitorHeight - (root.borders.bottom != -9999 ? root.borders.bottom : root.border) - 0.5 * root.size
		root.bounds.left = 0.5 * root.size + (root.borders.left != -9999 ? root.borders.left : root.border)
		root.bounds.right = root.monitorWidth - (root.borders.right != -9999 ? root.borders.right : root.border) - 0.5 * root.size
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
			!root.images.every(el => { return el.url != candidate })
		) {
			candidate = root.paths[Math.floor(Math.random() * root.paths.length)]
		}
		const coords = generateCoordinates()
		const rotation = root.maxRotation * Math.random() - 0.5 * root.maxRotation
		root.currentZ++
		return { "url": candidate, "posX": coords.x, "posY": coords.y, "posZ": root.currentZ, "rot": rotation }
	}

	function generateCoordinates(): var {
		const attempts = []

		while(attempts.length < root.images.count + 1) {
			let x = root.monitorWidth * Math.random()
			let y = root.monitorHeight * Math.random()

			let prevSummedOverlap = 0
			let currentRot = 2 * 3.14 * Math.random()
			let summedOverlap
			let currentStepSize = root.stepSize

			for (let i = 0; i < Math.pow(2, root.images.count); i++) {
				const newCoords = clampedMove(x, y, currentStepSize, currentRot)
				x = newCoords.x
				y = newCoords.y

				summedOverlap = root.images.reduce((acc, el) => {
					let distance = computeOverlap({posX: x, posY: y}, el)
					return acc + Math.pow(distance, 2)
				}, 0)

				if(summedOverlap == 0) {
					break;
				} else if(summedOverlap > prevSummedOverlap) {
					currentRot = 2 * 3.14 * Math.random()
				}
				prevSummedOverlap = summedOverlap
			}

			attempts.push({x: x, y: y, summedOverlap: summedOverlap})
			if(summedOverlap == 0) break;
		}

		return attempts.reduce((best, el) => {
			return el.summedOverlap < best.summedOverlap ? el : best
		})
	}

	function clampedMove(x, y, stepSize, rot) {
		x = x + stepSize * Math.sin(rot)
		y = y + stepSize * Math.cos(rot)

		x = Math.max(root.bounds.left, Math.min(x, root.bounds.right))
		y = Math.max(root.bounds.top, Math.min(y, root.bounds.bottom))

		return {x: x, y: y}
	}

	function computeOverlap(el1, el2): real {
		let distance = Math.sqrt(Math.pow(el1.posX - el2.posX, 2.0), Math.pow(el1.posX - el2.posY, 2.0))
		const upperLimit = 1.5 * root.size
		distance = distance > upperLimit ? 0 : upperLimit - distance
		return distance
	}
}
