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

	property string profile: ""
	property var targetPaths: []
	property var targetStrings: []

	signal updated()

	Process {
		id: targetDeviceChangeListener
		running: true
		command: [ "dbus-monitor", "--system", "path='/org/shadowblip/InputPlumber'" ]
		stdout: SplitParser {
			splitMarker: "signal "
			onRead: () => targetDevicePathGetterTimeout.restart()
		}
		onRunningChanged: if (!running) running = true
	}


	Timer {
		id: targetDevicePathGetterTimeout
		interval: 500; running: true; repeat: false
		onTriggered: targetDevicePathGetter.running = true
	}
	Process {
		id: targetDevicePathGetter
		running: false
		command: ["busctl", "get-property", "--json=short", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/CompositeDevice0", "org.shadowblip.Input.CompositeDevice", "TargetDevices",]
		stdout: SplitParser { onRead: rawData => {
			targetPaths = JSON.parse(rawData).data

			targetStrings = []
			resetTargetDeviceNameGetter()
			profileGetter.running = true
		} }
	}

	Process {
		id: profileGetter
		running: false
		command: ["busctl", "get-property", "--json=short", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/CompositeDevice0", "org.shadowblip.Input.CompositeDevice", "ProfileName",]
		stdout: SplitParser { onRead: rawData => {
			root.profile = JSON.parse(rawData).data
		} }
	}


	Process {
		id: targetDeviceNameGetter
		running: false
		command: []
		stdout: SplitParser { onRead: rawData => {
			const data = JSON.parse(rawData)

			targetStrings.push(data.data)
			targetPaths.shift()
		} }
		onRunningChanged: resetTargetDeviceNameGetter()
	}
	function resetTargetDeviceNameGetter() {
		if (targetDeviceNameGetter.running == false && targetPaths.length > 0) {
		targetDeviceNameGetter.command = [ "busctl", "get-property", "--json=short", "org.shadowblip.InputPlumber", targetPaths[0], "org.shadowblip.Input.Target", "DeviceType" ]
		targetDeviceNameGetter.running = true
		} else if(targetPaths.length == 0) {
			//notify event-listeners
			root.updated()
		}
	}


	function setTargetDevices(devices) {
		const command = [ "busctl", "call", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/CompositeDevice0", "org.shadowblip.Input.CompositeDevice", "SetTargetDevices", "as" ]
		command.push(devices.length)

		targetDeviceSetter.running= false
		targetDeviceSetter.command= command.concat(devices)
		targetDeviceSetter.running= true
	}
	Process {
		id: targetDeviceSetter
		running: false
		command: []
		stdout: SplitParser { onRead: data => console.log(data) }
	}


	function setProfile(name) {
		const command = [ "busctl", "call", "org.shadowblip.InputPlumber", "/org/shadowblip/InputPlumber/CompositeDevice0", "org.shadowblip.Input.CompositeDevice", "LoadProfilePath", "s" ]
		command.push("/etc/nixos/niri/inputplumber/"+name+".yaml")

		profileSetter.running= false
		profileSetter.command= command
		profileSetter.running= true
	}
	Process {
		id: profileSetter
		running: false
		command: []
		stdout: SplitParser { onRead: data => console.log(data) }
	}
}
