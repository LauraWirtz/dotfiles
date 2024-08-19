{ config, pkgs, inputs, ... }: {
  services.xserver = {
	enable = true;
	displayManager.gdm.enable = true;
	displayManager.gdm.wayland = true;
	desktopManager.gnome.enable = true;
  };

#  services.displayManager.gdm = {
#	enable = true;
#	autoLogin.enable = false;
#	autoLogin.user = "laura";
#	wayland.enable = true;
#	nvidiaWayland = true;
#  };

  environment.gnome.excludePackages = (with pkgs; [
	gnome-calendar
	gnome-console
	gnome-photos
	gnome-terminal
	gnome-tour
	gnome-tweaks
	cheese
	epiphany
	evince
	geary
	gedit
	totem
	simple-scan
  ]) ++ (with pkgs.gnome; [
	gnome-music
	gnome-characters
	tali # poker game
	iagno # go game
	hitori # sudoku game
	atomix # puzzle game
	gnome-weather
	gnome-contacts
	gnome-maps
	gnome-clocks
  ]);

  environment.systemPackages = [
	pkgs.gnome-tweaks
	pkgs.gnome-menus

	pkgs.gnome-extension-manager
    pkgs.gnomeExtensions.blur-my-shell
	pkgs.gnomeExtensions.pop-shell
	pkgs.gnomeExtensions.arcmenu
	pkgs.gnomeExtensions.dash-to-panel
#	pkgs.gnomeExtensions.wallpaper-slideshow

	pkgs.variety
  ];

  hardware.pulseaudio.enable = false;
}
