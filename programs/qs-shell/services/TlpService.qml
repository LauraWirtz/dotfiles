pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	id:root

	readonly property string dbusService: "org.freedesktop.UPower.PowerProfiles"
	readonly property string dbusObject: "/org/freedesktop/UPower/PowerProfiles"
	readonly property string dbusInterface: "org.freedesktop.UPower.PowerProfiles"

	readonly property string dbusPropertiesInterface: "org.freedesktop.DBus.Properties"
	readonly property string dbusSignal: "PropertiesChanged"

	property string profile: ""
	property string newProfile: ""

	Process {
		id: statusInitializer
		running: true
		command: [ "busctl", "get-property", "--json=short", root.dbusService, root.dbusObject, root.dbusInterface, "ActiveProfile" ]
		stdout: StdioCollector { onStreamFinished: () => {
			root.profile = JSON.parse(text).data
		} }
	}
	Process {
		id: statusUpdater
		running: true
		command: [ "busctl", "wait", "-N", "1", "--json=short", root.dbusObject, root.dbusPropertiesInterface, root.dbusSignal ]
		stdout: StdioCollector { onStreamFinished: () => {
			const reply = JSON.parse(text).data[1]
			if(Object.keys(reply)[0] == "ActiveProfile") root.profile = reply["ActiveProfile"].data
			statusUpdater.running = true
		} }
	}
	Process {
		id: statusSetter
		running: false
		command: [ "busctl", "set-property", root.dbusService, root.dbusObject, root.dbusInterface, "ActiveProfile", "s", root.newProfile ]
	}

	function setProfile(profile: string): void {
		newProfile = profile
		statusSetter.running = true
	}
}
