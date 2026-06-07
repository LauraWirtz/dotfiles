{ config, pkgs, ... }:
{
	services.tlp.settings = {
		TLP_PROFILE_DEFAULT="BAL";
		TLP_DEFAULT_MODE="BAL";
		TLP_AUTO_SWITCH=1;
		TLP_PROFILE_AC="PRF";
		TLP_PROFILE_BAT="BAL";

		SOUND_POWER_SAVE_ON_AC=10;
		SOUND_POWER_SAVE_ON_BAT=1;
		SOUND_POWER_SAVE_ON_SAV=1;

		RADEON_DPM_PERF_LEVEL_ON_AC="auto";
		RADEON_DPM_PERF_LEVEL_ON_BAT="low";
		RADEON_DPM_PERF_LEVEL_ON_SAV="low";
		RADEON_DPM_STATE_ON_AC="performance";
		RADEON_DPM_STATE_ON_BAT="battery";
		RADEON_DPM_STATE_ON_SAV="battery";
		AMDGPU_ABM_LEVEL_ON_AC=0;
		AMDGPU_ABM_LEVEL_ON_BAT=0;
		AMDGPU_ABM_LEVEL_ON_SAV=3;

		WIFI_PWR_ON_BAT="off";


		CPU_DRIVER_OPMODE_ON_AC="guided";
		CPU_DRIVER_OPMODE_ON_BAT="active";
		CPU_DRIVER_OPMODE_ON_SAV="active";
		CPU_SCALING_GOVERNOR_ON_AC="schedutil";
		CPU_SCALING_GOVERNOR_ON_BAT="powersave";
		CPU_SCALING_GOVERNOR_ON_SAV="powersave";
		PLATFORM_PROFILE_ON_AC="performance";
		PLATFORM_PROFILE_ON_BAT="low-power";
		PLATFORM_PROFILE_ON_SAV="low-power";
		CPU_SCALING_MIN_FREQ_ON_AC=419175;
		CPU_SCALING_MAX_FREQ_ON_AC=5134889;
		CPU_SCALING_MIN_FREQ_ON_BAT=419175;
		CPU_SCALING_MAX_FREQ_ON_BAT=5134889;
		CPU_SCALING_MIN_FREQ_ON_SAV=419175;
		CPU_SCALING_MAX_FREQ_ON_SAV=5134889;
		CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
		CPU_ENERGY_PERF_POLICY_ON_BAT="power";
		CPU_ENERGY_PERF_POLICY_ON_SAV="power";

		PCIE_ASPM_ON_AC="default";
		PCIE_ASPM_ON_BAT="powersupersave";
		PCIE_ASPM_ON_SAV="powersupersave";

		USB_EXCLUDE_AUDIO=0;
	};

	networking.hostName = "laura-steamdeck";

	services.xserver.xkb.layout = "us, de";
	fonts.fontconfig.subpixel.rgba = "vrgb";

	environment.variables = {
		RADV_FORCE_VRS = "2x2";
		RADV_PERFTEST = "sam";
		VKD3D_CONFIG = "no_upload_hvv";
		RADV_DEBUG = "novrsflatshading";
	};

	programs.qs-lockscreen.enable = true;
	programs.qs-keyboard.enable = true;
# 	programs.steam.extest.enable = true;
	services.inputplumber.enable = true;
	programs.ydotool.enable = true;
	programs.ydotool.group = "wheel";

	environment.systemPackages = with pkgs; [
		powertop
	];
}
