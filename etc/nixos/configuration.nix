{ config, pkgs, inputs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      timeout = null;
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  nix.gc = {
      automatic = true;
      dates = "day";
      options = "--delete-older-than 7d";
  };

  fileSystems."/etc/nixos" = {
    depends = [ "/home/laura/dotfiles/etc/nixos" ];
    device = "/home/laura/dotfiles/etc/nixos";
    fsType = "none";
    options = [ "bind"];
  };

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };


  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
  ];


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  users.users.laura = {
    isNormalUser = true;
    description = "Laura";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };


  programs.bash.shellAliases = {
    e = "nvim";
    f = "ls -hAl --group-directories-first";
    keeb = "sudo sleep 10 && sudo mount /dev/disk/by-label/MT.KEY /media/keeb/ && sudo cp ~/qmk_firmware/ymdk_id75_Laura.uf2 /media/keeb/";
  };

  programs.nano.enable = false;
  programs.neovim.enable = true ;
  programs.neovim.defaultEditor = true;
  programs.autojump.enable = true;

  environment.systemPackages = with pkgs; [
    anki-bin
    floorp
    fuzzel
    gimp
    git
    kitty
    neofetch
    qimgv
    qmk
  ];


  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "23.11";
}
