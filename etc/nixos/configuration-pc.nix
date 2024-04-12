{ config, pkgs, inputs, ... }:
{
  boot.initrd.luks.devices."luks-7d197a16-0a89-4449-9436-2522b74c2ab4".device = "/dev/disk/by-uuid/7d197a16-0a89-4449-9436-2522b74c2ab4";


  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/3b3775ff-058a-4a90-a5c7-7bc35bc22503";
    fsType = "ext4";
    options = [
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
      "exec"
    ];
  };
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/bc7fd759-0391-455b-b8a9-c8c375197248";
    fsType = "ext4";
    options = [
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount
      "exec"
    ];
  };
  fileSystems."/home/laura/Documents" = {
    depends = [ "/mnt/data" ];
    device = "/mnt/data/Documents";
    fsType = "none";
    options = [ "bind"];
   };
  fileSystems."/home/laura/Pictures" = {
    depends = [ "/mnt/data" ];
    device = "/mnt/data/Pictures";
    fsType = "none";
    options = [ "bind"];
   };
  fileSystems."/home/laura/Music" = {
    depends = [ "/mnt/data" ];
    device = "/mnt/data/Music";
    fsType = "none";
    options = [ "bind"];
   };


  networking.hostName = "laura-pc";


  services.xserver = {
    layout = "us";
  };
  console.keyMap = "us";


  nixpkgs.config.allowUnfreePredicate = with pkgs.lib; pkg: builtins.elem (pkgs.lib.getName pkg) [
    "nvidia"
    "nvidia-x11"
    "cudatoolkit"
    "steam"
    "steam-original"
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = false;
    open = false;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = with pkgs; [
    blender
    dolphin-emu-beta
    quodlibet
    steam
    qmk

	wineWowPackages.unstable
  ];
}
