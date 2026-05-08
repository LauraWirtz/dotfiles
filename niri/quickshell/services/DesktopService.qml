// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
	readonly property var unsortedEntries: DesktopEntries.applications.values
	property var sortedEntries: []

	function byId(id) { return DesktopEntries.byId(id) }
	function heuristicLookup(name) { return DesktopEntries.heuristicLookup(name) }

	Component.onCompleted: {createSortedEntries(); updated()}

	signal updated()

	function searchCategories(categories, term): bool {
		for(var entry in categories) {
			if(categories[entry] == term) return true
		}
		return false
	}

	function customNames(name): string {
		switch(name) {
			case "GNU Image Manipulation Program": return "GIMP";
			case "Fcitx 5 Configuration": return "Fcitx5 Config";
			case "TmForever": return "TmUnited";
			default: return name;
		}
	}
	function customIcons(name): string {
		switch(name) {
			case "steam": return "/run/current-system/sw/share/icons/hicolor/256x256/apps/steam.png";
			case "org.kde.dolphin": return "system-file-manager";
			case "kate": return "kwrite";
			case "org.kde.kate": return "kwrite";
			default: return name;
		}
	}

	function createSortedEntries() {
		const unsorted = DesktopEntries.applications.values

		sortedEntries = Array.from(unsorted).sort((a, b) => customNames(a.name).localeCompare(customNames(b.name)))
	}

	function getFilteredEntries(include, ids) {
		if (include) {
			return sortedEntries.filter(el => {
				return ids.some(id => {
					return el.id == id
				})
			}).sort((a, b) => {
				return ids.findIndex(el => { return el == a.id }) - ids.findIndex(el => { return el == b.id })
			})
		} else {
			return sortedEntries.filter(el => {
				return ids.every(id => {
					return el.id != id
				})
			})
		}
	}

	Connections {
		target: DesktopEntries

		function onApplicationsChanged() {
			createSortedEntries()
			root.updated()
		}
	}
}
