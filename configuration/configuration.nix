{ config, pkgs, lib, ... }:
{
	boot = {
		kernelPackages = pkgs.linuxPackages_latest;
		kernelParams = [ "nowatchdog" ];
		kernel.sysctl = { "vm.swappiness" = 1; };

		loader = {
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
			systemd-boot.configurationLimit = 3;
			timeout = 0;
		};
	};

	nix.gc = {
			automatic = true;
			persistent = true;
			dates = "daily";
			options = "--delete-older-than 7d";
	};
	nix.optimise = {
		automatic = true;
		persistent = true;
		dates = "weekly";
	};
	nix.settings.auto-optimise-store = true;

	services.dbus.implementation = "broker";
	services.tlp.enable = true;
	services.tlp.pd.enable = true;

	services.logind.settings.Login.HandlePowerKey = lib.mkDefault "hibernate";

	programs.bash.shellAliases = {
		e = "nano";
		f = "ls -hAl --group-directories-first";
		nixos-diff = ''nixos-rebuild build "$@" && nvd diff /run/current-system result'';
	};

	fonts = {
		packages = with pkgs; [
			google-fonts
		];
		fontDir.enable = true;
		fontconfig = {
			enable = true;
			hinting.style = "full";
			subpixel.rgba = lib.mkDefault "rgb";
			defaultFonts.serif = [ "Noto Serif"];
			defaultFonts.sansSerif = [ "Noto Sans"];
			defaultFonts.monospace  = [ "DejaVu Sans Mono"];
			defaultFonts.emoji  = [ "Noto Color Emoji"];
		};
	};

	hardware.bluetooth.enable = lib.mkDefault true;
	networking.networkmanager.enable = lib.mkDefault true;

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
	
	services.xserver.xkb.layout = lib.mkDefault "us";
	console.keyMap = lib.mkDefault "us";

	services.pulseaudio.enable = false;
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
	};


	documentation.nixos.enable = false;

	nixpkgs.config.allowUnfreePredicate = with pkgs.lib; pkg: builtins.elem (pkgs.lib.getName pkg) [
		"blender"
		"steam"
		"steam-original"
		"steam-run"
		"steam-unwrapped"
		"rar"
		"unrar"
	];

	programs.foot = {
		enable = true;
		settings = {
			main = {
				font = "Roboto Mono:size=10";
				pad = "10x10";
			};
			colors-dark = {
				background = "292c30";
				regular0 = "546E7A";  # black
				regular1 = "FF5252";  # red
				regular2 = "5CF19E";  # green
				regular3 = "FFD740";  # yellow
				regular4 = "40C4FF";  # blue
				regular5 = "FF4081";  # magenta
				regular6 = "64FCDA";  # cyan
				regular7 = "FFFFFF";  # white
				bright0 = "B0BEC5";   # bright black
				bright1 = "FF8A80";   # bright red
				bright2 = "B9F6CA";   # bright green
				bright3 = "FFE57F";   # bright yellow
				bright4 = "80D8FF";   # bright blue
				bright5 = "FF80AB";   # bright magenta
				bright6 = "A7FDEB";   # bright cyan
				bright7 = "FFFFFF";   # bright white
			};
		};
	};

	environment.systemPackages = with pkgs; [
		anki
		bottles
		floorp-bin
		gimp
		git
		nvd
		qimgv
		quodlibet-full
		rar
		unrar
	];


	nix.settings.experimental-features = [ "nix-command" "flakes" ];
	system.stateVersion = "25.05"; # Did you read the comment?
}
