pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id:root

	property var current: {}

	property string playState: "not-running"
	property real volume: 0.0
	property string shuffle: "inorder"
	property string repeat: "off"
	property real progress: 0.0

	property int fastPollCount: 40

	FileView {
		id: currentView
		path: "/home/laura/.config/quodlibet/current"
		watchChanges: true
		onFileChanged: reload()
		onTextChanged: {
			if(text() == ""){
				retryLoad.running = true
			} else {
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
			}
		}
	}

	Timer {
		id: retryLoad
		interval: 1000; running: false; repeat: false
		onTriggered: { currentView.reload() }
	}

	Timer {
		interval: root.playState == "playing" ? 1000 : 5000; running: true; repeat: true
		onTriggered: { statusGetter.running = true }
	}
	Process {
		id: statusGetter
		running: false
		command: [ "quodlibet", "--status", ]
		stdout: SplitParser { onRead: data => {
			const parts = data.split(" ")

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
