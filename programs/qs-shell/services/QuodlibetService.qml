pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id:root

	property bool hasCurrent: false
	property var current: {}

	property string playState: "not-running"
	property real volume: 0.0
	property string shuffle: "inorder"
	property string repeat: "off"
	property real progress: 0.0

	property int activeWidgetsCount: 0

	FileView {
		id: currentView
		path: "/home/laura/.config/quodlibet/current"
		watchChanges: true
		onFileChanged: reload()
		onLoadFailed: {
			retryLoad.running = true
			hasCurrent = false
		}
		onLoaded: {
			const lines = text().split("\n")
			var newState = {}

			lines.forEach(el => {
				if(el) {
					const parts = el.split("=")
					const key = parts[0].match( /(\w+)/g )[0]
					const value = parts[1]
					newState[key] = value
				}
			})
			root.current = newState
			retryLoad.running = false
			hasCurrent = true
		}
	}

	Timer {
		id: retryLoad
		interval: activeWidgetsCount > 0 ? 1000 : 10000; running: false; repeat: false
		onTriggered: { currentView.reload() }
	}

	Timer {
		interval: 100; running: activeWidgetsCount > 0; repeat: true
		onTriggered: { statusGetter.running = true }
	}
	Process {
		id: statusGetter
		running: false
		command: [ "quodlibet", "--status", ]
		stdout: StdioCollector { onStreamFinished: () => {
			const parts = text.split(" ")

			root.playState = parts[0]
			root.volume = parts[2]
			root.shuffle = parts[3]
			root.repeat = parts[4]
			root.progress = parts[5]
		} }
	}
	Process {
		id: statusSetter
		running: false
	}

	function play(): void {
		Niri.spawn(["quodlibet", "--play"])
		root.playState = "playing"
	}

	function pause(): void {
		Niri.spawn(["quodlibet", "--pause"])
	}

	function rate(rating): void {
		Niri.spawn(["quodlibet", "--rating="+rating])
	}

	function next(): void {
		Niri.spawn(["quodlibet", "--next"])
		root.playState = "playing"
	}

	function previous(): void {
		Niri.spawn(["quodlibet", "--previous"])
	}

	function seek(time): void {
		Niri.spawn(["quodlibet", "--seek="+time])
	}
}
