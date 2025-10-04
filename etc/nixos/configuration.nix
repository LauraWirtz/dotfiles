{ config, pkgs, inputs, ... }: {

	boot = {
		kernelPackages = pkgs.linuxPackages_latest;

		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
			systemd-boot.configurationLimit = 3;
			timeout = 0;
		};
	};


	nix.gc = {
			automatic = true;
			dates = "*-*-* 00:08:00";
			options = "--delete-older-than 7d";
	};
	nix.optimise = {
		automatic = true;
		dates = [ "*-*-* 00:08:00" ];
	};
	nix.settings.auto-optimise-store = true;


	hardware.bluetooth.enable = true;
	services.blueman.enable = true;


	time.timeZone = "Europe/Berlin";
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
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
		noto-fonts-cjk-sans
		roboto
		roboto-mono
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


	hardware.graphics = {
		enable = true;
		enable32Bit = true;
	};


	programs.bash.shellAliases = {
		e = "nano";
		f = "ls -hAl --group-directories-first";
		nixos-diff = ''nixos-rebuild build "$@" && nvd diff /run/current-system result'';
	};

	programs.autojump.enable = true;
	documentation.nixos.enable = false;


	programs.steam.enable = true;


	nixpkgs.config.allowUnfreePredicate = with pkgs.lib; pkg: builtins.elem (pkgs.lib.getName pkg) [
		"blender"
		"steam"
		"steam-original"
		"steam-run"
		"steam-unwrapped"
	];

	environment.systemPackages = with pkgs; [
		anki-bin
		floorp-bin
		gimp
		git
		kitty
		libreoffice-qt6
		nvd
		pwvucontrol
		p7zip
		pzip
		qimgv
		qmk
		wpa_supplicant_gui
	];


	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	system.stateVersion = "23.11";
}
