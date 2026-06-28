{ config, lib, pkgs, modulesPath, ... }:

{
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
	boot.initrd.kernelModules = [ "usbhid" ];
	boot.kernelModules = [ "kvm-amd" ];
	boot.extraModulePackages = [];

	fileSystems."/" =
		{ device = "/dev/mapper/luks-root";
			fsType = "f2fs";
			options = [ "atgc" "gc_merge" "noatime" ];
		};

	boot.initrd.luks.devices = {
		"luks-root".device = "/dev/disk/by-uuid/41574655-83b4-472d-9a0d-089f086580d7";
		"luks-root".allowDiscards = true;
		"luks-root".bypassWorkqueues = true;

		"luks-swap".device = "/dev/disk/by-uuid/2a32f383-f8ab-4996-9a6f-74dce37f0af1";
		"luks-swap".allowDiscards = true;
		"luks-swap".bypassWorkqueues = true;

		"luks-data".device = "/dev/disk/by-uuid/ec6491ba-eb7a-4766-b567-f21811e22b72";
		"luks-data".allowDiscards = true;
		"luks-data".bypassWorkqueues = true;
	};

	fileSystems."/boot" = {
	device = "/dev/disk/by-uuid/EAE3-3732";
			fsType = "vfat";
			options = [ "fmask=0077" "dmask=0077" ];
		};

	swapDevices = [
		{ device = "/dev/mapper/luks-swap"; options = [ "discard" ]; }
	];
		boot.resumeDevice = "/dev/mapper/luks-swap";


	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
