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
		running: root.enabled
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
		root.paths = root.paths.filter(el => { return el != url })
	}

	function addPostcard(): void {
		const coords = generateCoordinates(root.size, root.size)
		root.images.append({ "service": this, "url": getUniqueUrl(), "posX": coords.x, "posY": coords.y, "rot": 0, "w": 0, "h": 0 })
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
			const coords = generateCoordinates(subject.w, subject.h)
			const candidate = {"posX": coords.x, "posY": coords.y, "w": subject.w, "h": subject.h}

			const summedOverlap = computeSummedOverlap(candidate)
			if(summedOverlap < startingPoint.summedOverlap) startingPoint = {x: coords.x, y: coords.y, summedOverlap: summedOverlap}
			if(summedOverlap == 0) break
		}

		root.images.setProperty(index, "posX", startingPoint.x)
		root.images.setProperty(index, "posY", startingPoint.y)
		root.images.setProperty(index, "rot", (Math.random() + Math.random() - 1) * root.maxRotation)
		root.images.move(index, root.images.count - 1, 1)
	}

	function generateCoordinates(width, height): var {
		const x = (root.bounds.right - root.bounds.left - width) * Math.random() + root.bounds.left + width/2
		const y = (root.bounds.bottom - root.bounds.top - height) * Math.random() + root.bounds.top + height/2
		return {x: x, y: y}
	}

	function computeSummedOverlap(element): real {
		let summedOverlap = root.images.reduce((acc, el) => {
			const overlap = computeOverlap(element, el)
			return acc + overlap
		}, 0)

		summedOverlap += root.exclusionZones.reduce((acc, el) => {
			const formedEl = { posX: el.x + el.width/2, posY: el.y + el.height/2, w: el.width, h: el.height }
			const overlap = computeOverlap(element, formedEl)
			return acc + overlap
		}, 0)

		return summedOverlap
	}

	function computeOverlap(el1, el2): real {
		const el1TopLeft = {x: el1.posX - el1.w/2, y: el1.posY - el1.h/2}
		const el1BottomRight = {x: el1.posX + el1.w/2, y: el1.posY + el1.h/2}
		const el2TopLeft = {x: el2.posX - el2.w/2, y: el2.posY - el2.h/2}
		const el2BottomRight = {x: el2.posX + el2.w/2, y: el2.posY + el2.h/2}

		const overlap = Math.max(0, Math.min(el1BottomRight.x, el2BottomRight.x) - Math.max(el1TopLeft.x, el2TopLeft.x)) * Math.max(0, Math.min(el1BottomRight.y, el2BottomRight.y) - Math.max(el1TopLeft.y, el2TopLeft.y))
		return overlap
	}
}
