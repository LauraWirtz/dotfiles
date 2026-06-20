// ClockWidget.qml
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../items"
import "../services"


import QtQuick.Controls.Material

RowLayout {
	Material.theme: Material.Dark
	Material.accent: Material.Green
	Layout.fillWidth: true
	// spacing: 8

	PwObjectTracker {
		objects: Pipewire.defaultAudioSink
	}

	Button {
		// Layout.leftMargin: -12

		icon.name: "audio-volume-high"
		icon.width: 24
		icon.height: 24
		display: AbstractButton.IconOnly
		background: {}
		padding: 0
		Layout.margins: -12
	}

	BreezeSlider {
		Layout.fillWidth: true
		Layout.preferredWidth: 300
		Layout.topMargin: -12
		Layout.bottomMargin: -12
		padding: 0

		id: slider

		from: 0
		to: 1
		stepSize: 0.01

		value: Pipewire.defaultAudioSink.audio.volume

		onMoved: Pipewire.defaultAudioSink.audio.volume = slider.value
	}
}

