{ config, lib, pkgs, modulesPath, ... }:

{
	imports =
		[ (modulesPath + "/installer/scan/not-detected.nix")
		];

	boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
	boot.initrd.kernelModules = [];
	boot.kernelModules = [ "kvm-amd" ];
	boot.extraModulePackages = [];

	fileSystems."/" =
		{ device = "/dev/mapper/luks-root";
			fsType = "f2fs";
			options = [ "atgc" "gc_merge" "noatime" ];
		};

	boot.initrd.luks.devices = {
		"luks-root".device = "/dev/disk/by-uuid/048efcc0-0cfa-4295-8ae8-bcaa6f0a0cda";
		"luks-root".allowDiscards = true;
		"luks-root".bypassWorkqueues = true;
		"luks-root".crypttabExtraOpts = [ "tpm2-device=auto" ];

		"luks-swap".device = "/dev/disk/by-uuid/386fb810-eaf6-40b6-bedd-e57f07cf788e";
		"luks-swap".allowDiscards = true;
		"luks-swap".bypassWorkqueues = true;
		"luks-swap".crypttabExtraOpts = [ "tpm2-device=auto" ];

		"luks-data".device = "/dev/disk/by-uuid/27120715-1c13-42f0-9249-b4ca44e69d77";
		"luks-data".allowDiscards = true;
		"luks-data".bypassWorkqueues = true;
		"luks-data".crypttabExtraOpts = [ "tpm2-device=auto" ];
	};

	fileSystems."/boot" =
		{ device = "/dev/disk/by-uuid/EAE3-3732";
			fsType = "vfat";
			options = [ "fmask=0077" "dmask=0077" ];
		};

	swapDevices =
		[ {
			device = "/dev/mapper/luks-swap";
			options = [ "discard" ];
		} ];
		boot.resumeDevice = "/dev/mapper/luks-swap";


	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
