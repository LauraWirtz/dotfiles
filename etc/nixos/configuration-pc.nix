{ config, pkgs, inputs, ... }:
let
	amdgpu-kernel-module = pkgs.callPackage ./amdgpu-kernel-module.nix {
		# Make sure the module targets the same kernel as your system is using.
		kernel = config.boot.kernelPackages.kernel;
	};
	# linuxPackages_latest 6.13 (or linuxPackages_zen 6.13)
	amdgpu-stability-patch = pkgs.fetchpatch {
		name = "amdgpu-stability-patch";
		url = "https://github.com/torvalds/linux/compare/ffd294d346d185b70e28b1a28abe367bbfe53c04...SeryogaBrigada:linux:4c55a12d64d769f925ef049dd6a92166f7841453.diff";
		hash = "sha256-q/gWUPmKHFBHp7V15BW4ixfUn1kaeJhgDs0okeOGG9c=";
	};
	/*
	# linuxPackages_zen 6.12
	amdgpu-stability-patch = pkgs.fetchpatch {
		name = "amdgpu-stability-patch-zen";
		url = "https://github.com/zen-kernel/zen-kernel/compare/fd00d197bb0a82b25e28d26d4937f917969012aa...WhiteHusky:zen-kernel:f4c32ca166ad55d7e2bbf9adf121113500f3b42b.diff";
		hash = "sha256-bMT5OqBCyILwspWJyZk0j0c8gbxtcsEI53cQMbhbkL8=";
	};
	*/
in
	{
	# amdgpu instability with context switching between compute and graphics
	# https://bbs.archlinux.org/viewtopic.php?id=301798
	# side-effects: plymouth fails to show at boot, but does not interfere with booting
	boot.extraModulePackages = [
		(amdgpu-kernel-module.overrideAttrs (_: {
		patches = [
			amdgpu-stability-patch
		];
		}))
	];


	fileSystems."/run/mnt/data" = {
		device = "/dev/disk/by-uuid/3b3775ff-058a-4a90-a5c7-7bc35bc22503";
		fsType = "ext4";
		options = [
			"users" # Allows any user to mount and unmount
			"nofail" # Prevent system from failing if this drive doesn't mount
			"exec"
		];
	};

	fileSystems."/etc/nixos" = {
		depends = [ "/run/mnt/data" ];
		device = "/run/mnt/data/dotfiles/etc/nixos";
		fsType = "none";
		options = [ "bind"];
	};
	fileSystems."/home/laura/Documents" = {
		depends = [ "/run/mnt/data" ];
		device = "/run/mnt/data/laura/Documents";
		fsType = "none";
		options = [ "bind"];
	 };
	fileSystems."/home/laura/Downloads" = {
		depends = [ "/run/mnt/data" ];
		device = "/run/mnt/data/laura/Downloads";
		fsType = "none";
		options = [ "bind"];
	 };
	fileSystems."/home/laura/Music" = {
		depends = [ "/run/mnt/data" ];
		device = "/run/mnt/data/laura/Music";
		fsType = "none";
		options = [ "bind"];
	 };
	fileSystems."/home/laura/Pictures" = {
		depends = [ "/run/mnt/data" ];
		device = "/run/mnt/data/laura/Pictures";
		fsType = "none";
		options = [ "bind"];
	 };



	networking.hostName = "laura-pc";



	services.xserver.xkb.layout = "us";
	console.keyMap = "us";


	services.logind.powerKey = "ignore";

# 	kill all user-processes
# 	pgrep -u laura -l | grep -vE  "Hyprland|systemd" | grep -oE ^[0123456789]+ | xargs kill

# 	close floorp
# 	hyprctl dispatch sendshortcut CTRL, q, class:floorp

	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver.videoDrivers = ["amdgpu"];
# 	programs.corectrl.enable = true;
# 	programs.corectrl.gpuOverclock.enable = true;
# 	programs.corectrl.gpuOverclock.ppfeaturemask = "0xfffd3fff";
# 	systemd.packages = with pkgs; [ lact ];
# 	systemd.services.lactd.wantedBy = ["multi-user.target"];
	boot.kernelParams = [ "amdgpu.ppfeaturemask=0xfffd3fff" ];


	services.hardware.openrgb.enable = true;
	services.hardware.openrgb.package = pkgs.openrgb-with-all-plugins;

	environment.systemPackages = with pkgs; [
		blender-hip
		bottles
		cemu
		clinfo
		dolphin-emu-beta
		gammastep
		gimp
		lact
		qpwgraph
		xorg.xrandr
#		yuzu.yuzu
	];
}
