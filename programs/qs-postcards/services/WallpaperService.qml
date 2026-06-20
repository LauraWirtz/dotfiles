import Quickshell
import Quickshell.Io
import QtQuick

Item {
	id: root
	visible: false

	component Borders: QtObject {
		property int top: -9999
		property int bottom: -9999
		property int left: -9999
		property int right: -9999
	}

	required property int monitorWidth		// monitor width
	required property int monitorHeight		// monitor height

	property int border: 0					// clear space around monitor edge (can be negative)
	property Borders borders: Borders {}	// clear space around monitor edge (can be negative) (per edge)
	property list<rect> exclusionZones

	required property string source
	required property int size				// postcard size
	required property int count				// # of postcards
	property int maxRotation: 0				// maximum degree of rotation
	property int interval: 60000			// interval of new postcards

	property int attempts: 500				// maximum attempts for finding ideal postcard position

	property var paths: []
	property Borders bounds: Borders {}

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
		interval: root.interval; running: false; repeat: true
		onTriggered: {
			root.images.setProperty(0, "url", getUniqueUrl())
		}
	}

	Process {
		id: pathfinder
		running: true
		command: [ "find", root.source, "-type", "f" ]
		stdout: StdioCollector { onStreamFinished: () => {
			root.paths = text.split("\n")

			root.bounds.top = root.borders.top != -9999 ? root.borders.top : root.border
			root.bounds.bottom = root.monitorHeight - (root.borders.bottom != -9999 ? root.borders.bottom : root.border)
			root.bounds.left = (root.borders.left != -9999 ? root.borders.left : root.border)
			root.bounds.right = root.monitorWidth - (root.borders.right != -9999 ? root.borders.right : root.border)

			root.populate()
			cardUpdater.running = true
		} }
	}

	function populate(): void {
		for (let i = 0; i < root.count; i++) {
			addPostcard()
		}
	}

	function handleMissingImage(index: int): void {
		const url = root.images.get(index).url
		root.images.setProperty(index, "url", getUniqueUrl())
		root.pathfinder.running = true
	}

	function addPostcard(): void {
		const coords = generateCoordinates(root.size, root.size)
		root.images.append({ "service": this, "url": getUniqueUrl(), "rectX": coords.x, "rectY": coords.y, "rot": 0, "rectWidth": root.size, "rectHeight": root.size })
	}

	function getUniqueUrl(): string {
		let candidate = ""
		while(
			!(candidate.includes(".png") || candidate.includes(".jpg") || candidate.includes(".jpeg")) ||
			!root.images.every(el => { return el.url != candidate })
		) {
			candidate = root.paths[Math.floor(Math.random() * root.paths.length)]
		}
		return candidate
	}

	function positionPostcard(index: int): void {
		const subject = root.images.get(index)

		let startingPoint = {summedOverlap: 999999999}
		for (let i = 0; i < root.attempts; i++) {
			const coords = generateCoordinates(subject.rectWidth, subject.rectHeight)
			const candidate = {"rectX": coords.x, "rectY": coords.y, "rectWidth": subject.rectWidth, "rectHeight": subject.rectHeight}

			const summedOverlap = computeSummedOverlap(candidate)
			if(summedOverlap < startingPoint.summedOverlap) startingPoint = {x: coords.x, y: coords.y, summedOverlap: summedOverlap}
			if(summedOverlap == 0) break
		}

		root.images.setProperty(index, "rectX", startingPoint.x)
		root.images.setProperty(index, "rectY", startingPoint.y)
		root.images.setProperty(index, "rot", (Math.random() + Math.random() - 1) * root.maxRotation)
		root.images.move(index, root.images.count - 1, 1)
	}

	function generateCoordinates(width, height): var {
		const x = (root.bounds.right - root.bounds.left - width) * Math.random() + root.bounds.left
		const y = (root.bounds.bottom - root.bounds.top - height) * Math.random() + root.bounds.top
		return {x: x, y: y}
	}

	function computeSummedOverlap(element): real {
		let summedOverlap = root.images.reduce((acc, el) => {
			const overlap = computeOverlap(element, el)
			return acc + overlap
		}, 0)

		summedOverlap += root.exclusionZones.reduce((acc, el) => {
			const formedEl = { rectX: el.x, rectY: el.y, rectWidth: el.width, rectHeight: el.height }
			const overlap = computeOverlap(element, formedEl)
			return acc + overlap
		}, 0)

		return summedOverlap
	}

	function computeOverlap(el1, el2): real {
		const overlap = Math.max(0, Math.min(el1.rectX + el1.rectWidth, el2.rectX + el2.rectWidth) - Math.max(el1.rectX, el2.rectX)) * Math.max(0, Math.min(el1.rectY + el1.rectHeight, el2.rectY + el2.rectHeight) - Math.max(el1.rectY, el2.rectY))
		return overlap
	}
}
