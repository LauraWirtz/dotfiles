{ config, lib, ... }: {
	home.file = {
		".config/pipewire".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/home/pc/.config/pipewire";

		".floorp".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.floorp";
		".local/share/bottles".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/bottles";
		".local/share/Cemu".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/Cemu";
		".local/share/dolphin-emu".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/dolphin-emu";
		".config/Ryujinx".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.config/Ryujinx";
		".git-credentials".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.git-credentials";
	};
}
