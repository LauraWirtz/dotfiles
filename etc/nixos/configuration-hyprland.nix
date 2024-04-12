{ config, pkgs, inputs, ... }: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = with pkgs; "${pkgs.hyprland}/bin/Hyprland";
        user = "laura";
      };
      default_session = initial_session;
    };
  };

  environment.systemPackages = with pkgs; [
    hyprland
    hyprlock
    hyprshade
    wpaperd
  ];
}
