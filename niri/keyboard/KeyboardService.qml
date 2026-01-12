pragma Singleton

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	readonly property int scale: 60
	readonly property int padding: 3
	readonly property int rounding: 4

	property list<var> layout: [
		{label: "`", labelCaps: "~", key: "41", x:0, y:0, width:1, height:1, active:false},
		{label: "1", labelCaps: "!", key: "02", x:1, y:0, width:1, height:1, active:false},
		{label: "2", labelCaps: "@", key: "03", x:2, y:0, width:1, height:1, active:false},
		{label: "3", labelCaps: "#", key: "04", x:3, y:0, width:1, height:1, active:false},
		{label: "4", labelCaps: "$", key: "05", x:4, y:0, width:1, height:1, active:false},
		{label: "5", labelCaps: "%", key: "06", x:5, y:0, width:1, height:1, active:false},
		{label: "6", labelCaps: "^", key: "07", x:6, y:0, width:1, height:1, active:false},
		{label: "7", labelCaps: "&", key: "08", x:7, y:0, width:1, height:1, active:false},
		{label: "8", labelCaps: "*", key: "09", x:8, y:0, width:1, height:1, active:false},
		{label: "9", labelCaps: "(", key: "10", x:9, y:0, width:1, height:1, active:false},
		{label: "0", labelCaps: ")", key: "11", x:10, y:0, width:1, height:1, active:false},
		{label: "-", labelCaps: "_", key: "12", x:11, y:0, width:1, height:1, active:false},
		{label: "=", labelCaps: "+", key: "13", x:12, y:0, width:1, height:1, active:false},
		{label: "⌫", key: "14", x:13, y:0, width:2, height:1, active:false},

		{label: "⇥", key: "15", x:0, y:1, width:1.5, height:1, active:false},
		{label: "q", labelCaps: "Q", key: "16", x:1.5, y:1, width:1, height:1, active:false},
		{label: "w", labelCaps: "W", key: "17", x:2.5, y:1, width:1, height:1, active:false},
		{label: "e", labelCaps: "E", key: "18", x:3.5, y:1, width:1, height:1, active:false},
		{label: "r", labelCaps: "R", key: "19", x:4.5, y:1, width:1, height:1, active:false},
		{label: "t", labelCaps: "T", key: "20", x:5.5, y:1, width:1, height:1, active:false},
		{label: "y", labelCaps: "Y", key: "21", x:6.5, y:1, width:1, height:1, active:false},
		{label: "u", labelCaps: "U", key: "22", x:7.5, y:1, width:1, height:1, active:false},
		{label: "i", labelCaps: "I", key: "23", x:8.5, y:1, width:1, height:1, active:false},
		{label: "o", labelCaps: "O", key: "24", x:9.5, y:1, width:1, height:1, active:false},
		{label: "p", labelCaps: "P", key: "25", x:10.5, y:1, width:1, height:1, active:false},
		{label: "[", labelCaps: "{", key: "26", x:11.5, y:1, width:1, height:1, active:false},
		{label: "]", labelCaps: "}", key: "27", x:12.5, y:1, width:1, height:1, active:false},
		{label: "\\", labelCaps: "|", key: "43", x:13.5, y:1, width:1.5, height:1, active:false},

		{label: "esc", key: "01", x:0, y:2, width:1.75, height:1, active:false},
		{label: "a", labelCaps: "A", key: "30", x:1.75, y:2, width:1, height:1, active:false},
		{label: "s", labelCaps: "S", key: "31", x:2.75, y:2, width:1, height:1, active:false},
		{label: "d", labelCaps: "D", key: "32", x:3.75, y:2, width:1, height:1, active:false},
		{label: "f", labelCaps: "F", key: "33", x:4.75, y:2, width:1, height:1, active:false},
		{label: "g", labelCaps: "G", key: "34", x:5.75, y:2, width:1, height:1, active:false},
		{label: "h", labelCaps: "H", key: "35", x:6.75, y:2, width:1, height:1, active:false},
		{label: "j", labelCaps: "J", key: "36", x:7.75, y:2, width:1, height:1, active:false},
		{label: "k", labelCaps: "K", key: "37", x:8.75, y:2, width:1, height:1, active:false},
		{label: "l", labelCaps: "L", key: "38", x:9.75, y:2, width:1, height:1, active:false},
		{label: ";", labelCaps: ":", key: "39", x:10.75, y:2, width:1, height:1, active:false},
		{label: "'", labelCaps: '"', key: "40", x:11.75, y:2, width:1, height:1, active:false},
		{label: "↵", key: "28", x:12.75, y:2, width:2.25, height:1, active:false},

		{label: "⇧", key: "42", x:0, y:3, width:2.25, height:1, active:false, exec: value => KeyboardService.setShiftL(value)},
		{label: "z", labelCaps: "Z", key: "44", x:2.25, y:3, width:1, height:1, active:false},
		{label: "x", labelCaps: "X", key: "45", x:3.25, y:3, width:1, height:1, active:false},
		{label: "c", labelCaps: "C", key: "46", x:4.25, y:3, width:1, height:1, active:false},
		{label: "v", labelCaps: "V", key: "47", x:5.25, y:3, width:1, height:1, active:false},
		{label: "b", labelCaps: "B", key: "48", x:6.25, y:3, width:1, height:1, active:false},
		{label: "n", labelCaps: "N", key: "49", x:7.25, y:3, width:1, height:1, active:false},
		{label: "m", labelCaps: "M", key: "50", x:8.25, y:3, width:1, height:1, active:false},
		{label: ",", labelCaps: "<", key: "51", x:9.25, y:3, width:1, height:1, active:false},
		{label: ".", labelCaps: ">", key: "52", x:10.25, y:3, width:1, height:1, active:false},
		{label: "/", labelCaps: "?", key: "53", x:11.25, y:3, width:1, height:1, active:false},
		{label: "⇧", key: "54", x:12.25, y:3, width:2.75, height:1, active:false, exec: value => KeyboardService.setShiftR(value)},

		{label: "ctrl", key: "29", x:0, y:4, width:1.25, height:1, active:false},
		{label: "win", key: "125", x:1.25, y:4, width:1.25, height:1, active:false},
		{label: "alt", key: "56", x:2.5, y:4, width:1.25, height:1, active:false},
		{label: "", key: "57", x:3.75, y:4, width:6, height:1, active:false},
		{label: "←", key: "105", x:9.75, y:4, width:1, height:1, active:false},
		{label: "↓", key: "108", x:10.75, y:4, width:1, height:1, active:false},
		{label: "↑", key: "103", x:11.75, y:4, width:1, height:1, active:false},
		{label: "→", key: "106", x:12.75, y:4, width:1, height:1, active:false},
		{label: "ctrl", key: "97", x:13.75, y:4, width:1.25, height:1, active:false},
	]

	property bool visible: false

	property bool isShift: false
	property bool isShiftL: false
	property bool isShiftR: false

	property bool isCaps: false


	signal updated()

	function show() { root.visible = true }
	function hide() { root.visible = false }
	function toggle() { root.visible = !root.visible }

	function setShiftL(value) {
		isShiftL = value
		isShift = isShiftL || isShiftR
	}
	function setShiftR(value) {
		isShiftR = value
		isShift = isShiftL || isShiftR
	}

	IpcHandler {
		target: "root"
		function enable(): void { root.visible = true }
		function disable(): void { root.visible = false }
		function toggle(): void { root.visible = !root.visible }
	}

	function formKeypressCommand(key, down) {
		const command = ["ydotool", "key", `${key}:${down ? "1" : "0"}`,]
		return command
	}
	function formMouseclickCommand(key, down) {
		const command = ["ydotool", "click", `0x${down ? "4" : "8"}${key}`,]
		return command
	}

	function registerKeyPresses(list): void {
		var pressedKeys = []
		list.forEach( point => {
			const normalX = point.x / root.scale
			const normalY = point.y / root.scale
			console.log(normalX)
			const pressedKey = root.layout.findIndex( el => {
				return normalX > el.x && normalX < el.x + el.width && normalY > el.y && normalY < el.y + el.height
			})
			if(pressedKey != undefined) pressedKeys.push(pressedKey.toString())
		} )
		console.log(pressedKeys)

		for(var i in root.layout) {
			console.log(i+": "+root.layout[i].label+root.layout[i].active+ pressedKeys.includes(i))
			if(root.layout[i].active && !pressedKeys.includes(i.toString())) {
				console.log("release")
				root.layout[i].active = false
			} else if(!root.layout[i].active && pressedKeys.includes(i.toString())) {
				console.log("press")
				root.layout[i].active = true
			}
		}
	}
}
