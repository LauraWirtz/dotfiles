{ config, lib, ... }: {
  home.file = {
    ".config/hypr/hyprland-specific.conf".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/hypr/hyprland-pc.conf";
    ".config/wpaperd".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/wpaperd/pc";
    ".config/pipewire".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/pipewire";

    ".config/dolphin-emu".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/.config/dolphin-emu";

    ".floorp".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.floorp";

    ".local/share/bottles".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/bottles";
    ".local/share/Cemu".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/Cemu";
    ".local/share/dolphin-emu".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/dolphin-emu";
    ".local/share/yuzu".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.local/share/yuzu";

    ".git-credentials".source = config.lib.file.mkOutOfStoreSymlink "/run/mnt/data/laura/.git-credentials";
  };
}
