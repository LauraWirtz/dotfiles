{ config, pkgs, inputs, ... }: {
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = with pkgs; "${pkgs.kdePackages.plasma-desktop}/bin/startplasma-wayland";
        user = "laura";
      };
      default_session = initial_session;
    };
  };
}
