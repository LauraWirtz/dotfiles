pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id:root

	property string profile: ""

	function set(val): void {
		statusSetter.command = val
		statusSetter.running = true
	}

	Timer {
		interval: 5000; running: true; repeat: true
		onTriggered: { statusGetter.running = true }
	}
	Process {
		id: statusGetter
		running: false
		command: [ "tlpctl", "get", ]
		stdout: SplitParser { onRead: data => root.profile = data }
	}
	Process {
		id: statusSetter
		running: false
	}
}
