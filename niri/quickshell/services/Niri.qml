pragma Singleton

pragma ComponentBehavior: Bound

import QtCore
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.WindowManager

Singleton {
	id: root

	readonly property string socketPath: Quickshell.env("NIRI_SOCKET")

	property var workspaces: []
	property var windows: []

	property bool inOverview: false

	property int currentKeyboardLayoutIndex: 0
	property var keyboardLayoutNames: []

	property bool hasInitialConnection: false

	signal windowUrgentChanged
	SocketItem {
		id: eventStreamSocket
		path: root.socketPath
		connected: true

		onConnectionStateChanged: {
			if (connected) {
				send('"EventStream"')
			}
		}

		parser: SplitParser {
			onRead: line => {
				try {
					const event = JSON.parse(line)
					handleNiriEvent(event)
				} catch (e) {
					console.warn("NiriService: Failed to parse event:", line, e)
				}
			}
		}
	}

	SocketItem {
		id: requestSocket
		path: root.socketPath
		connected: true
	}


	function handleNiriEvent(event) {
		const eventType = Object.keys(event)[0]
		switch (eventType) {
		case 'WorkspacesChanged':
			handleWorkspacesChanged(event.WorkspacesChanged)
			break
		case 'WorkspaceActivated':
			handleWorkspaceActivated(event.WorkspaceActivated)
			break
		case 'WorkspaceActiveWindowChanged':
			handleWorkspaceActiveWindowChanged(event.WorkspaceActiveWindowChanged)
			break
		case 'WindowFocusChanged':
			handleWindowFocusChanged(event.WindowFocusChanged)
			break
		case 'WindowsChanged':
			handleWindowsChanged(event.WindowsChanged)
			break
		case 'WindowOpenedOrChanged':
			handleWindowOpenedOrChanged(event.WindowOpenedOrChanged)
			break
		case 'WindowClosed':
			windows = windows.filter(w => w.id !== event.WindowClosed.id)
			break
		case 'OverviewOpenedOrClosed':
			inOverview = event.OverviewOpenedOrClosed.is_open
			break
		case 'KeyboardLayoutsChanged':
			keyboardLayoutNames = event.KeyboardLayoutsChanged.keyboard_layouts.names
			currentKeyboardLayoutIndex = event.KeyboardLayoutsChanged.keyboard_layouts.current_idx
			break
		case 'KeyboardLayoutSwitched':
			currentKeyboardLayoutIndex = event.KeyboardLayoutSwitched.idx
			break
		case 'WorkspaceUrgencyChanged':
			// handleWorkspaceUrgencyChanged(event.WorkspaceUrgencyChanged)
			break
		}
	}

	function sortWindowsByLayout(windowList) {
		return [...windowList].sort((a, b) => {
			return a.id - b.id
		})
	}

	function handleWindowsChanged(data) {
		windows = sortWindowsByLayout(data.windows)
	}

	function handleWindowOpenedOrChanged(data) {
		if (!data.window) return

		const newWindow = data.window

		let isWindowNew = true

		let updatedWindows = windows.map(el => {
			const updatedWindow = {}
			for (let prop in el) {
				updatedWindow[prop] = el[prop]
			}
			if(updatedWindow.id == newWindow.id) {
				isWindowNew = false
				return newWindow
			} else {
				return updatedWindow
			}
		})
		if(isWindowNew) {
			updatedWindows.push(newWindow)
		}

		windows = updatedWindows
	}

	function handleWorkspacesChanged(data) {
		workspaces = data.workspaces
	}

	function handleWorkspaceActivated(data) {
		const workspace = workspaces.find(el => {return el.id == data.id})

		workspaces = workspaces.map(el => {
			const got_activated = el.id === workspace.id

			if (el.output === workspace.output) {
				el.is_active = got_activated
			}

			if (data.focused) {
				el.is_focused = got_activated
			}
			return el
		})
	}

	function handleWorkspaceActiveWindowChanged(data) {
		const workspace = workspaces.find(el => { return el.id == data.workspace_id } )
		workspace.active_window_id = data.active_window_id
	}

	function handleWindowFocusChanged(data) {
		let updatedWindows = windows.map(el => {
			const updatedWindow = {}
			for (let prop in el) {
				updatedWindow[prop] = el[prop]
			}
			updatedWindow.is_focused = updatedWindow.id == data.id
			return updatedWindow
		})
		windows = updatedWindows
	}



	function handleWorkspaceUrgencyChanged(data) {
		const ws = root.workspaces[data.id]
		if (!ws) return

		ws.is_urgent = data.urgent

		const idx = workspaces.findIndex(w => w.id === data.id)
		if (idx >= 0) {
			workspaces[idx].is_urgent = data.urgent
		}

		windowUrgentChanged()
	}

	function send(request) {
		if (!requestSocket.connected) return false
		requestSocket.send(request)
		return true
	}

	function spawn(command) {
		return send({"Action": {"Spawn": {"command": command}}})
	}

	function doScreenTransition() {
		return send({"Action": {"DoScreenTransition": {"delay_ms": 0}}})
	}

	function switchToWorkspace(workspaceIndex) {
		return send({"Action": {"FocusWorkspace": {"reference": {"Index": workspaceIndex}}}})
	}

	function focusWindow(windowId) {
		return send({"Action": {"FocusWindow": {"id": windowId}}})
	}

	function powerOffMonitors() {
		return send({"Action": {"PowerOffMonitors": {}}})
	}
	function powerOnMonitors() {
		return send({"Action": {"PowerOnMonitors": {}}})
	}

	function cycleKeyboardLayout() {
		return send({"Action": {"SwitchLayout": {"layout": "Next"}}})
	}

	function closeWindow(windowId) {
		if(windowId) {
			return send({"Action": {"CloseWindow": {"id": windowId}}})
		} else {
			return send({"Action": {"CloseWindow": {}}})
		}
	}

	function toggleOverview() {
		return send({"Action": {"ToggleOverview": {}}})
	}
	function openOverview() {
		return send({"Action": {"OpenOverview": {}}})
	}
	function closeOverview() {
		return send({"Action": {"CloseOverview": {}}})
	}

	function switchPresetWindowWidth(windowId) {
		if(windowId) {
			return send({"Action": {"SwitchPresetWindowWidth": {"id": windowId}}})
		} else {
			return send({"Action": {"SwitchPresetWindowWidth": {}}})
		}
	}

	function fullscreenWindow(windowId) {
		if(windowId) {
			return send({"Action": {"FullscreenWindow": {"id": windowId}}})
		} else {
			return send({"Action": {"FullscreenWindow": {}}})
		}
	}
	function maximizeWindowToEdges() {
		return send({"Action": {"MaximizeWindowToEdges": {}}})
	}

	function toggleWindowFloating(windowId) {
		if(windowId) {
			return send({"Action": {"ToggleWindowFloating": {"id": windowId}}})
		} else {
			return send({"Action": {"ToggleWindowFloating": {}}})
		}
	}

	function centerWindow(windowId) {
		if(windowId) {
			return send({"Action": {"CenterWindow": {"id": windowId}}})
		} else {
			return send({"Action": {"CenterWindow": {}}})
		}
	}

	function focusColumnLeft() {
		return send({"Action": {"FocusColumnLeft": {}}})
	}
	function focusColumnRight() {
		return send({"Action": {"FocusColumnRight": {}}})
	}

	function focusWorkspaceDown() {
		return send({"Action": {"FocusWorkspaceDown": {}}})
	}
	function focusWorkspaceUp() {
		return send({"Action": {"FocusWorkspaceUp": {}}})
	}

	function getCurrentWorkspaceNumber() {
		if (focusedWorkspaceIndex >= 0 && focusedWorkspaceIndex < workspaces.length) {
			return workspaces[focusedWorkspaceIndex].idx + 1
		}
		return 1
	}

	function findWorkspaceIndexById(id: int): int {
		const index = workspaces.findIndex(w => w.id === id)
		return index
	}

	function getCurrentKeyboardLayoutName() {
		if (currentKeyboardLayoutIndex >= 0 && currentKeyboardLayoutIndex < keyboardLayoutNames.length) {
			return keyboardLayoutNames[currentKeyboardLayoutIndex]
		}
		return ""
	}

	function getWindowsByScreen(screen: string): var {
		const activeWorkspaceId = workspaces.find(el => {
			return el.output == screen && el.is_active
		}).id
		const screenWindows = windows.filter(el => {
			return el.workspace_id == activeWorkspaceId
		}).sort((a, b) => {
			return a.layout.pos_in_scrolling_layout[0] - b.layout.pos_in_scrolling_layout[0]
		})
		return screenWindows
	}
}
