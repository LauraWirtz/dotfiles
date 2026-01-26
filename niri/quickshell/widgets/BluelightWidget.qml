// ClockWidget.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"

import QtQuick.Controls.Material

RowLayout {
	id: root
	Material.theme: Material.Dark
	Material.accent: Material.LightBlue
	Layout.fillWidth: true

	property string tempBuffer: ""
	property string modeBuffer: ""

	Button {

		icon.name: "redshift-status-on"
		icon.width: 24
		icon.height: 24
		display: AbstractButton.IconOnly
		background: {}
		padding: 0
		Layout.margins: -12
	}

	Slider {
		Layout.fillWidth: true
		Layout.alignment: Qt.AlignVCenter
		Layout.preferredWidth: 300
		Layout.topMargin: -12
		Layout.bottomMargin: -12
		padding: 0

		id: slider

		from: 2500
		to: 6500
		stepSize: 500

		onMoved: {
			root.tempBuffer = value.toString()
			root.modeBuffer = "static"
			processQueue()
		}

		states: [
			State {
				name: "ACTIVE"
				when: (Niri.inOverview)
				PropertyChanges { statusGetter.running: true }
			}
		]
	}
	Button {
		id: autoButton
		icon.name: "clock"
		icon.width: 24
		icon.height: 24
		text: "Auto"

		onClicked: {
			root.modeBuffer = "finish_by"
			processQueue()
		}
	}

	Process {
		id: statusSetter
		running: false
		onRunningChanged: processQueue()
	}

	function processQueue() {
		if(!statusSetter.running) {
			if(root.tempBuffer != "") {
				statusSetter.command = [ "sunsetr", "set", "static_temp="+root.tempBuffer ]
				root.tempBuffer = ""
				statusSetter.running = true
			}
			else if(root.modeBuffer != "") {
				statusSetter.command = [ "sunsetr", "set", "transition_mode="+root.modeBuffer ]
				root.tempBuffer = ""
				statusSetter.running = true
			}
		}
	}

	Process {
		id: statusGetter
		running: false
		command: [ "sunsetr", "status", "--json", "--follow" ]
		stdout: SplitParser { onRead: rawData => {
			const event = JSON.parse(rawData)
			if(event.event_type == "state_applied") {
				autoButton.enabled = event.period == "static"
				slider.value = event.current_temp
			} else if(event.event_type == "period_changed") {
				autoButton.enabled = event.to_period == "static"
			}
		}}
	}
}
