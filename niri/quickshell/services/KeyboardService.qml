pragma Singleton

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
	id: root

	readonly property int scale: 65
	readonly property int padding: 3
	readonly property int rounding: 4

	property list<var> layout: [
		{label: "`", labelCaps: "~", key: "Key_Apostrophe", x:0, y:0, width:1, height:1},
		{label: "1", labelCaps: "!", key: "KEY_1", x:1, y:0, width:1, height:1},
		{label: "2", labelCaps: "@", key: "KEY_2", x:2, y:0, width:1, height:1},
		{label: "3", labelCaps: "#", key: "KEY_3", x:3, y:0, width:1, height:1},
		{label: "4", labelCaps: "$", key: "KEY_4", x:4, y:0, width:1, height:1},
		{label: "5", labelCaps: "%", key: "KEY_5", x:5, y:0, width:1, height:1},
		{label: "6", labelCaps: "^", key: "KEY_6", x:6, y:0, width:1, height:1},
		{label: "7", labelCaps: "&", key: "KEY_7", x:7, y:0, width:1, height:1},
		{label: "8", labelCaps: "*", key: "KEY_8", x:8, y:0, width:1, height:1},
		{label: "9", labelCaps: "(", key: "KEY_9", x:9, y:0, width:1, height:1},
		{label: "0", labelCaps: ")", key: "KEY_0", x:10, y:0, width:1, height:1},
		{label: "-", labelCaps: "_", key: "KEY_MINUS", x:11, y:0, width:1, height:1},
		{label: "=", labelCaps: "+", key: "KEY_EQUAL", x:12, y:0, width:1, height:1},
		{label: "⌫", labelCaps: "⌫", key: "KEY_BACKSPACE", x:13, y:0, width:2, height:1},

		{label: "⇥", labelCaps: "⇥", key: "KEY_TAB", x:0, y:1, width:1.5, height:1},
		{label: "q", labelCaps: "Q", key: "KEY_Q", x:1.5, y:1, width:1, height:1},
		{label: "w", labelCaps: "W", key: "KEY_W", x:2.5, y:1, width:1, height:1},
		{label: "e", labelCaps: "E", key: "KEY_E", x:3.5, y:1, width:1, height:1},
		{label: "r", labelCaps: "R", key: "KEY_R", x:4.5, y:1, width:1, height:1},
		{label: "t", labelCaps: "T", key: "KEY_T", x:5.5, y:1, width:1, height:1},
		{label: "y", labelCaps: "Y", key: "KEY_Y", x:6.5, y:1, width:1, height:1},
		{label: "u", labelCaps: "U", key: "KEY_U", x:7.5, y:1, width:1, height:1},
		{label: "i", labelCaps: "I", key: "KEY_I", x:8.5, y:1, width:1, height:1},
		{label: "o", labelCaps: "O", key: "KEY_O", x:9.5, y:1, width:1, height:1},
		{label: "p", labelCaps: "P", key: "KEY_P", x:10.5, y:1, width:1, height:1},
		{label: "[", labelCaps: "{", key: "KEY_LEFTBRACE", x:11.5, y:1, width:1, height:1},
		{label: "]", labelCaps: "}", key: "KEY_RIGHTBRACE", x:12.5, y:1, width:1, height:1},
		{label: "\\", labelCaps: "|", key: "KEY_BACKSLASH", x:13.5, y:1, width:1.5, height:1},

		{label: "esc", labelCaps: "esc", key: "KEY_ESC", x:0, y:2, width:1.75, height:1},
		{label: "a", labelCaps: "A", key: "KEY_A", x:1.75, y:2, width:1, height:1},
		{label: "s", labelCaps: "S", key: "KEY_S", x:2.75, y:2, width:1, height:1},
		{label: "d", labelCaps: "D", key: "KEY_D", x:3.75, y:2, width:1, height:1},
		{label: "f", labelCaps: "F", key: "KEY_F", x:4.75, y:2, width:1, height:1},
		{label: "g", labelCaps: "G", key: "KEY_G", x:5.75, y:2, width:1, height:1},
		{label: "h", labelCaps: "H", key: "KEY_H", x:6.75, y:2, width:1, height:1},
		{label: "j", labelCaps: "J", key: "KEY_J", x:7.75, y:2, width:1, height:1},
		{label: "k", labelCaps: "K", key: "KEY_K", x:8.75, y:2, width:1, height:1},
		{label: "l", labelCaps: "L", key: "KEY_L", x:9.75, y:2, width:1, height:1},
		{label: ";", labelCaps: ":", key: "KEY_SEMICOLON", x:10.75, y:2, width:1, height:1},
		{label: "'", labelCaps: '"', key: "KEY_APOSTROPHE", x:11.75, y:2, width:1, height:1},
		{label: "↵", labelCaps: "↵", key: "KEY_ENTER", x:12.75, y:2, width:2.25, height:1},

		{label: "⇧", labelCaps: "⇧", key: "KEY_LEFTSHIFT", x:0, y:3, width:2.25, height:1, shift: true},
		{label: "z", labelCaps: "Z", key: "KEY_Z", x:2.25, y:3, width:1, height:1},
		{label: "x", labelCaps: "X", key: "KEY_X", x:3.25, y:3, width:1, height:1},
		{label: "c", labelCaps: "C", key: "KEY_C", x:4.25, y:3, width:1, height:1},
		{label: "v", labelCaps: "V", key: "KEY_V", x:5.25, y:3, width:1, height:1},
		{label: "b", labelCaps: "B", key: "KEY_B", x:6.25, y:3, width:1, height:1},
		{label: "n", labelCaps: "N", key: "KEY_N", x:7.25, y:3, width:1, height:1},
		{label: "m", labelCaps: "M", key: "KEY_M", x:8.25, y:3, width:1, height:1},
		{label: ",", labelCaps: "<", key: "KEY_COMMA", x:9.25, y:3, width:1, height:1},
		{label: ".", labelCaps: ">", key: "KEY_DOT", x:10.25, y:3, width:1, height:1},
		{label: "/", labelCaps: "?", key: "KEY_SLASH", x:11.25, y:3, width:1, height:1},
		{label: "⇧", labelCaps: "⇧", key: "KEY_RIGHTSHIFT", x:12.25, y:3, width:2.75, height:1, shift: true},

		{label: "ctrl", labelCaps: "ctrl", key: "KEY_LEFTCTRL", x:0, y:4, width:1.25, height:1},
		{label: "win", labelCaps: "win", key: "KEY_LEFTMETA", x:1.25, y:4, width:1.25, height:1},
		{label: "alt", labelCaps: "alt", key: "KEY_LEFTALT", x:2.5, y:4, width:1.25, height:1},
		{label: "", labelCaps: "", key: "KEY_SPACE", x:3.75, y:4, width:6, height:1},
		{label: "←", labelCaps: "←", key: "KEY_LEFT", x:9.75, y:4, width:1, height:1},
		{label: "↓", labelCaps: "↓", key: "KEY_DOWN", x:10.75, y:4, width:1, height:1},
		{label: "↑", labelCaps: "↑", key: "KEY_UP", x:11.75, y:4, width:1, height:1},
		{label: "→", labelCaps: "→", key: "KEY_RIGHT", x:12.75, y:4, width:1, height:1},
		{label: "ctrl", labelCaps: "ctrl", key: "KEY_RIGHTCTRL", x:13.75, y:4, width:1.25, height:1},
	]

	property bool visible: true

	property bool isShift: false
	property bool isCaps: false


	signal updated()

	function show() { root.visible = true }
	function hide() { root.visible = false }
	function toggle() { root.visible = !root.visible }

	function formKeypressCommand(key, down) {
		const command = ["busctl", "call", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/devices/target/keyboard0", "org.shadowblip.Input.Keyboard", "SendKey", "sb",]
		command.push(key)
		command.push(down ? "1" : "0")
		return command
	}

	Process {
		id: profileGetter
		running: false
		command: ["busctl", "call", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/devices/target/keyboard0", "org.shadowblip.Input.Keyboard", "SendKey", "sb",]
		stdout: SplitParser { onRead: rawData => {
			console.log(JSON.parse(rawData).data)
		} }
	}

}
