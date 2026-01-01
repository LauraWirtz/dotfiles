pragma Singleton

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Singleton {
	id: root

	readonly property string dBusServicePath: "org.shadowblip.InputPlumber"
	readonly property string dBusCompDeviceInterfacePath: "org.shadowblip.Input.CompositeDevice"
	readonly property string dBusCompDevicePath: "/org/shadowblip/InputPlumber/CompositeDevice0"

	property var targets: []
	property var targetStrings: []

	property bool hasInitialConnection: false

	// DBusItem { id: runner }

	Process {
		id: targetDeviceRemovedListenerr
		running: true
		command: [ "dbus-monitor", "--system", "path='/org/shadowblip/InputPlumber'" ]
		stdout: SplitParser {
			splitMarker: "signal "
			onRead: data => {
				console.log(data)
				const eventType = extractEventType(data)
				const objectPath = extractObjectPath(data)
				console.log(objectPath)
			}
		}
		onRunningChanged: if (!running) running = true
	}
	Process {
		id: targetDeviceSetter
		running: true
		command: [ "dbus-monitor", "--system", "path='/org/shadowblip/InputPlumber'" ]
		stdout: SplitParser {
			onRead: data => {
				console.log(data)
			}
		}
	}

	function setTargetDevices(devices) {
		const command = [ "busctl", "call", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/CompositeDevice0", "org.shadowblip.Input.CompositeDevice", "SetTargetDevices", "as" ]
		command.push(devices.length)

		console.log(command.concat(devices))

		targetDeviceSetter.running= false
		targetDeviceSetter.command= command.concat(devices)
		targetDeviceSetter.running= true

	}

	function extractEventType(string): string {
		return string.match(/member=\w+/)[0].split("=")[1]
	}
	function extractObjectPath(string): string {
		return string.match(/object path ".+"/)[0].split('"')[1]
	}

	// function updateTargetDeviceName() {
	// 	const command = [ "get-property", "--json=pretty", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/CompositeDevice0", "org.shadowblip.Input.CompositeDevice", "TargetDevices" ]
	// 	const handler = (data) => { console.log(data) }
 //
	// 	runner.makeRequest(command, handler)
	// }
}
