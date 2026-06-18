{ config, pkgs, inputs, ... }:
{
	boot.kernelPackages = pkgs.linuxPackagesFor
		(pkgs.linuxKernel.kernels.linux_latest.override {
			NIX_ENFORCE_NO_NATIVE = "0";
			extraMakeFlags = [
				# Gcc flags.
				"KCFLAGS+=-O3"
				"KCFLAGS+=-march=znver5"
				"KCFLAGS+=-mtune=znver5"

				# Clang/llvm flags
				"KCFLAGS+=-O3"
				"KCFLAGS+=-mtune=znver5"
				"KCFLAGS+=-march=znver5"
				"KCFLAGS+=-Wno-unused-command-line-argument"
				"CC=${pkgs.llvmPackages.clang-unwrapped}/bin/clang"
				"AR=${pkgs.llvm}/bin/llvm-ar"
				"NM=${pkgs.llvm}/bin/llvm-nm"
				"LD=${pkgs.lld}/bin/ld.lld"
				"LLVM=1"
			];
	});

	fileSystems."/run/mnt/data" = {
		device = "/dev/mapper/luks-data";
		fsType = "ext4";
		options = [
			"nouser"
			"noexec"
			"nosuid"
			"nodev"
			"noatime"
			"data=journal"
			"X-mount.owner=laura"
		];
	};

	fileSystems."/run/mnt/steam1" = {
		device = "/dev/disk/by-uuid/d63224c3-335a-4f49-9bf8-10f364f4ffaa";
		fsType = "f2fs";
		options = [
			"nofail" # Prevent system from failing if this drive doesn't mount
			"nouser"
			"exec"
			"nosuid"
			"nodev"
			"noatime"
			"atgc"
			"gc_merge"
			"X-mount.owner=laura"
		];
	};

	fileSystems."/run/mnt/steam2" = {
		device = "/dev/disk/by-uuid/663c49a2-45a3-478a-bb1e-4181979137bd";
		fsType = "f2fs";
		options = [
			"nofail" # Prevent system from failing if this drive doesn't mount
			"nouser"
			"exec"
			"nosuid"
			"nodev"
			"noatime"
			"atgc"
			"gc_merge"
			"X-mount.owner=laura"
		];
	};

	services.tlp.settings = {
		TLP_PROFILE_DEFAULT="BAL";
		TLP_DEFAULT_MODE="BAL";
		TLP_AUTO_SWITCH=0;

		SOUND_POWER_SAVE_ON_AC=1;
		SOUND_POWER_SAVE_ON_BAT=1;
		SOUND_POWER_SAVE_ON_SAV=1;

		RADEON_DPM_PERF_LEVEL_ON_AC="high";
		RADEON_DPM_PERF_LEVEL_ON_BAT="low";
		RADEON_DPM_PERF_LEVEL_ON_SAV="low";
		RADEON_DPM_STATE_ON_AC="performance";
		RADEON_DPM_STATE_ON_BAT="battery";
		RADEON_DPM_STATE_ON_SAV="battery";
		AMDGPU_ABM_LEVEL_ON_AC=0;
		AMDGPU_ABM_LEVEL_ON_BAT=1;
		AMDGPU_ABM_LEVEL_ON_SAV=3;

		CPU_DRIVER_OPMODE_ON_AC="active";
		CPU_DRIVER_OPMODE_ON_BAT="active";
		CPU_DRIVER_OPMODE_ON_SAV="active";
		CPU_SCALING_GOVERNOR_ON_AC="powersave";
		CPU_SCALING_GOVERNOR_ON_BAT="powersave";
		CPU_SCALING_GOVERNOR_ON_SAV="powersave";
		PLATFORM_PROFILE_ON_AC="performance";
		PLATFORM_PROFILE_ON_BAT="low-power";
		PLATFORM_PROFILE_ON_SAV="low-power";
		CPU_SCALING_MIN_FREQ_ON_AC=624476;
		CPU_SCALING_MAX_FREQ_ON_AC=5455945;
		CPU_SCALING_MIN_FREQ_ON_BAT=624476;
		CPU_SCALING_MAX_FREQ_ON_BAT=5455945;
		CPU_SCALING_MIN_FREQ_ON_SAV=624476;
		CPU_SCALING_MAX_FREQ_ON_SAV=5455945;
		CPU_ENERGY_PERF_POLICY_ON_AC="performance";
		CPU_ENERGY_PERF_POLICY_ON_BAT="power";
		CPU_ENERGY_PERF_POLICY_ON_SAV="power";
		CPU_BOOST_ON_AC=1;
		CPU_BOOST_ON_BAT=0;
		CPU_BOOST_ON_SAV=0;


		PCIE_ASPM_ON_AC="default";
		PCIE_ASPM_ON_BAT="powersupersave";
		PCIE_ASPM_ON_SAV="powersupersave";

# 		USB_EXCLUDE_AUDIO=0;
		DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan";
		DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi wwan";
	};

	environment.variables = {
		RADV_FORCE_VRS = "2x2";
		RADV_PERFTEST = "sam";
		VKD3D_CONFIG = "no_upload_hvv";
		RADV_DEBUG = "novrsflatshading";
		MESA_GLTHREAD = "true";
	};

	networking.hostName = "laura-pc";

	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver.videoDrivers = [ "amdgpu" ];
	hardware.amdgpu.opencl.enable = true;

	programs.qs-postcards.enable = true;
	programs.qs-postcards.path = "/home/laura/Pictures/アニメ/";

	virtualisation.waydroid.enable = true;
	virtualisation.waydroid.package = pkgs.waydroid-nftables;

	environment.systemPackages = with pkgs; [
		geeqie
		imagemagick
		oxipng
		pkgsRocm.blender
		qmk
		stable-diffusion-cpp-rocm

		wl-clipboard
	];
}
