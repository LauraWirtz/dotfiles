{ config, pkgs, inputs, ... }:
let
#  unstable = import <nixos-unstable> {};
#  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in {
  imports = [
#    ./hardware-configuration.nix
#    ./hardware-pc.nix
#    (import "${home-manager}/nixos")
  ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;


  networking.networkmanager.enable = true;


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
    noto-fonts-emoji
    liberation_ttf
  ];


  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    config = {
      common.default = ["gtk"];
    };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.laura = {
    isNormalUser = true;
    description = "Laura";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

#  home-manager.users.laura = {
#    home.stateVersion = "23.11";
#  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    unstable.anki
    unstable.dolphin-emu-beta
    firefox
    git
    unstable-small.hypridle
    unstable-small.hyprland
    unstable-small.hyprlock
    unstable-small.hyprshade
    kitty
    neofetch
#    pyenv
#    python3
    quodlibet
    wget
    wofi
    unstable-small.wpaperd

    ranger
#    nnn
#    lf
  ];

#  services.flatpak.enable = true;
  # Flatseal
  # Quod Libet

  programs.steam.enable = true;


  system.stateVersion = "23.11";
}

