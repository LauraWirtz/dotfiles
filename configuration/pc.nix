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

	services.tlp.settings = {
		SOUND_POWER_SAVE_ON_AC=1;
		SOUND_POWER_SAVE_ON_BAT=1;
		SOUND_POWER_SAVE_ON_SAV=1;

		RADEON_DPM_PERF_LEVEL_ON_AC="auto";
		RADEON_DPM_PERF_LEVEL_ON_BAT="low";
		RADEON_DPM_PERF_LEVEL_ON_SAV="low";
		RADEON_DPM_STATE_ON_AC="performance";
		RADEON_DPM_STATE_ON_BAT="battery";
		RADEON_DPM_STATE_ON_SAV="battery";
		AMDGPU_ABM_LEVEL_ON_AC=0;
		AMDGPU_ABM_LEVEL_ON_BAT=1;
		AMDGPU_ABM_LEVEL_ON_SAV=3;

		CPU_DRIVER_OPMODE_ON_AC="guided";
		CPU_DRIVER_OPMODE_ON_BAT="guided";
		CPU_DRIVER_OPMODE_ON_SAV="guided";
		CPU_SCALING_GOVERNOR_ON_AC="schedutil";
		CPU_SCALING_GOVERNOR_ON_BAT="schedutil";
		CPU_SCALING_GOVERNOR_ON_SAV="schedutil";
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
	};

	environment.variables = {
		RADV_FORCE_VRS = "2x2";
		RADV_PERFTEST = "sam";
		VKD3D_CONFIG = "no_upload_hvv";
		RADV_DEBUG = "novrsflatshading";
	};

	networking.hostName = "laura-pc";

	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver.videoDrivers = ["amdgpu"];
	hardware.amdgpu.opencl.enable = true;

	environment.systemPackages = with pkgs; [
		pkgsRocm.blender
		qmk
	];
}
