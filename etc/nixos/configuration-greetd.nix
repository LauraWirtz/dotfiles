{ config, pkgs, inputs, ... }: {
  environment.systemPackages = [
    pkgs.greetd.tuigreet
  ];
  
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = with pkgs; "${pkgs.greetd.tuigreet}/bin/tuigreet";
        user = "greeter";
      };
      default_session = initial_session;
    };
  };
}
