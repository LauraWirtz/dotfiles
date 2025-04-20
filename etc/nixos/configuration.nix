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
	systemd.services.NetworkManager-wait-online.enable = false;


	nix.gc = {
			automatic = true;
			dates = "*-*-* 00:08:00";
			options = "--delete-older-than 1d";
	};
	nix.optimise = {
		automatic = true;
		dates = [ "*-*-* 00:08:00" ];
	};
	nix.settings.auto-optimise-store = true;


	networking.networkmanager.enable = true;
	hardware.bluetooth.enable = true;

# 	services.printing.enable = true;
# 	services.avahi = {
# 		enable = true;
# 		nssmdns4 = true;
# 		openFirewall = true;
# 	};


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
		sudo = "sudo ";
		e = "nvim";
		f = "ls -hAl --group-directories-first";
		keeb = "sudo echo 5 && sleep 1 && echo 4 && sleep 1 && echo 3 && sleep 1 && echo 2 && sleep 1 && echo 1 && sleep 1 && sudo mount /dev/disk/by-label/RPI-RP2 /run/mount/keeb/ && sudo cp /run/mnt/data/qmk_firmware/keebio_nyquist_rev4_Laura.uf2 /run/mount/keeb/";
		nixos-diff = ''nixos-rebuild build "$@" && nvd diff /run/current-system result'';
	};

	programs.nano.enable = false;
	programs.neovim.enable = true ;
	programs.neovim.defaultEditor = true;
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
		floorp
		gimp
		git
		kitty
		libreoffice-qt6
		nvd
		pavucontrol
		p7zip
		pzip
		qimgv
		qmk
	];


	nix.settings.experimental-features = [
		"nix-command"
		"flakes"
	];

	system.stateVersion = "23.11";
}
