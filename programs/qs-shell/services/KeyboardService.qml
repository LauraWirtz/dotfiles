pragma Singleton

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	function show(): void { enabler.running = true }
	function hide(): void { disabler.running = true }
	function toggle(): void { toggler.running = true }

	Process {
		id: enabler
		running: false
		command: [ "qs", "-p", "/etc/nixos/niri/keyboard/shell.qml", "ipc", "call", "root", "enable" ]
		stdout: SplitParser { onRead: data => console.log(data)}
	}
	Process {
		id: disabler
		running: false
		command: [ "qs", "-p", "/etc/nixos/niri/keyboard/shell.qml", "ipc", "call", "root", "disable" ]
		stdout: SplitParser { onRead: data => console.log(data)}
	}
	Process {
		id: toggler
		running: false
		command: [ "qs", "-p", "/etc/nixos/niri/keyboard/shell.qml", "ipc", "call", "root", "toggle" ]
		stdout: SplitParser { onRead: data => console.log(data)}
	}
}
