{ config, pkgs, inputs, ... }: {

  boot = {
    kernelPackages = pkgs.linuxPackages_6_8;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 3;
      timeout = null;
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;


  nix.gc = {
      automatic = true;
      dates = "day";
      options = "--delete-older-than 1d";
  };
  nix.optimise = {
	automatic = true;
	dates = [ "weekly" ];
  };
  nix.settings.auto-optimise-store = true;


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


  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };


  programs.bash.shellAliases = {
	sudo = "sudo ";
    e = "nvim";
    f = "ls -hAl --group-directories-first";
    keeb = "sudo echo 5 && sleep 1 && echo 4 && sleep 1 && echo 3 && sleep 1 && echo 2 && sleep 1 && echo 1 && sleep 1 && sudo mount /dev/disk/by-label/RPI-RP2 /media/keeb/ && sudo cp ~/qmk_firmware/keebio_nyquist_rev4_Laura.uf2 /media/keeb/";
  };

  programs.nano.enable = false;
  programs.neovim.enable = true ;
  programs.neovim.defaultEditor = true;
  programs.autojump.enable = true;


  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
#	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
#	gamescopeSession.enable = true;
  };

  nixpkgs.config.allowUnfreePredicate = with pkgs.lib; pkg: builtins.elem (pkgs.lib.getName pkg) [
	"blender"
	"steam"
    "steam-original"
	"steam-run"
	"nvidia"
    "nvidia-x11"
    "cudatoolkit"
	"cuda_cudart"
	"cuda_nvcc"
	"cuda_cccl"
  ];

  environment.systemPackages = with pkgs; [
    anki-bin
    floorp
    fuzzel
    gimp
    git
    kitty
	lutris
    neofetch
	pzip
    qimgv
    qmk
  ];

  environment.variables = {
	ANKI_WAYLAND = "1";
  };


  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "23.11";
}
