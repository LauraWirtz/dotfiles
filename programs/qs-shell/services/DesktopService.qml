// Time.qml
pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
	readonly property var entries: DesktopEntries.applications.values

	readonly property var config: [
		{
			mode: "include",
			layout: {
				size: 64,
				showText: false,
				showSections: false,
			},
			ids: [
				"firefox",
				"org.kde.dolphin",
				"org.kde.kate",
				"foot",
			],
		},
		{
			mode: "include",
			layout: {
				size: 64,
				showText: false,
				showSections: false,
			},
			ids: [
				"net.kuribo64.melonDS",
				"org.azahar_emu.Azahar",
				"dolphin-emu",
				"dev.eden_emu.eden",
			],
		},
		{
			mode: "exclude",
			layout: {
				size: 32,
				showText: true,
				showSections: true,
			},
			ids: [
				// "firefox",
				// "org.kde.dolphin",
				// "org.kde.kate",
				// "foot",

				// "net.kuribo64.melonDS",
				// "org.azahar_emu.Azahar",
				// "dolphin-emu",
				// "dev.eden_emu.eden",

				"startcenter",
				"base",
				"draw",
				"writer",
			],
		},
	]
	property var configuredEntries: []

	function configureEntries(): void {
		configuredEntries = config.map(menu => {
			switch(menu.mode) {
				case "include": return {layout: menu.layout, ids: getFilteredEntries(true, menu.ids)};
				case "exclude": return {layout: menu.layout, ids: getFilteredEntries(false, menu.ids)};
				default: return {};
			}
		})
	}

	function byId(id) { return DesktopEntries.byId(id) }
	function heuristicLookup(name) { return DesktopEntries.heuristicLookup(name) }

	function searchCategories(categories, term): bool {
		for(var entry in categories) {
			if(categories[entry] == term) return true
		}
		return false
	}

	function customNames(modelData): string {
		switch(modelData.id) {
			case "org.kde.partitionmanager": return "Partition Manager";
			case "io.github.quodlibet.QuodLibet": return "QuodLibet";
			default: return modelData.name;
		}
	}
	function customIcons(modelData): string {
		switch(modelData.id) {
			case "steam": return "/run/current-system/sw/share/icons/hicolor/256x256/apps/steam.png";
			case "org.kde.dolphin": return "system-file-manager";
			case "org.kde.kate": return "kwrite";
			case "org.kde.kwrite": return "kwrite";
			default: return modelData.icon;
		}
	}

	function compareNames(a: string, b: string): int { return a.localeCompare(b) }

	function getFilteredEntries(include, ids) {
		if (include) {
			return ids.map(el => {
				return entries.find(entry => { return entry.id == el})
			})
		} else {
			return entries.filter(el => {
				return ids.every(id => {
					return el.id != id
				})
			}).sort((a, b) => compareNames(customNames(a), (customNames(b))))
		}
	}

	Connections {
		target: DesktopEntries

		function onApplicationsChanged() {
			configureEntries()
		}
	}
}
