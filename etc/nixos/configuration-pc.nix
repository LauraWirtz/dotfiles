{ config, pkgs, inputs, ... }:
{
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



	services.logind.powerKey = "hibernate";



	services.xserver.videoDrivers = ["nvidia"];
	hardware.nvidia = {
		modesetting.enable = true;
		nvidiaSettings = false;
		open = false;
		powerManagement.enable = true;
		package = config.boot.kernelPackages.nvidiaPackages.beta;
	};



	environment.systemPackages = with pkgs; [
		(blender.override {
			cudaSupport = true;
		})
		bottles
		cemu
		dolphin-emu-beta
		gammastep
		gimp
		qpwgraph
		xorg.xrandr
		yuzu.yuzu
	];
}
