{ config, lib, ... }: {
	home.file = {
		".git-credentials".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.git-credentials";

		".config/niri/pc.kdl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/niri/pc.kdl";

		".config/mozilla".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.config/mozilla";
		".config/pipewire".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/pc/.config/pipewire";
		".config/wireplumber".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/pc/.config/wireplumber";
		".config/quodlibet".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.config/quodlibet";
		".config/sunsetr".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/pc/.config/sunsetr";

		".local/share/bottles".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/bottles";

		".config/dolphin-emu".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.config/dolphin-emu";
		".config/eden".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.config/eden";
		".local/share/dolphin-emu".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/dolphin-emu";
		".local/share/eden".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/eden";

		"Documents".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/Documents";
		"Downloads".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/Downloads";
		"Music".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/Music";
		"Pictures".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/Pictures";
	};
}
