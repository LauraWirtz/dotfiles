pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id:root

	property string profile: ""
	property int fastPollCount: 40

	function set(val): void {
		fastPollCount = 40
		statusSetter.command = val
		statusSetter.running = true
	}

	Timer {
		interval: root.fastPollCount > 0 ? 250 : 10000; running: true; repeat: true
		onTriggered: { statusGetter.running = true }
	}
	Process {
		id: statusGetter
		running: false
		command: [ "tlpctl", "get", ]
		stdout: SplitParser { onRead: data => {
			if(root.fastPollCount > 0) { root.fastPollCount-- }
			root.profile = data
		} }
	}
	Process {
		id: statusSetter
		running: false
	}
}
