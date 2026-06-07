{ config, lib, ... }: {
	home.file = {
		".config/niri/pc.kdl".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/.config/niri/pc.kdl";

		".config/pipewire".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/pc/.config/pipewire";
		".config/quodlibet".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.config/quodlibet";
		".config/sunsetr".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/pc/.config/sunsetr";
		".floorp".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.floorp";
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
