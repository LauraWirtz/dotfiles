// Time.qml
pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.UPower

Singleton {
  id: root
	readonly property var unsortedEntries: DesktopEntries.applications.values
	property var sortedEntries: []

	function byId(id) { return DesktopEntries.byId(id) }
	function heuristicLookup(name) { return DesktopEntries.heuristicLookup(name) }

	Component.onCompleted: createSortedEntries()

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

	function createSortedEntries() {
		const unsorted = DesktopEntries.applications.values

		sortedEntries = Array.from(unsorted).sort((a, b) => customNames(a.name).localeCompare(customNames(b.name)))
	}

	function getFilteredEntries(ids) {
		return sortedEntries.filter(el =>{
			for(var i in ids) {
				if(ids[i] == el.id) return false
			}
			return true
		})
	}

	Connections {
		target: DesktopEntries

		function onApplicationsChanged() {
			createSortedEntries()
		}
	}
}
