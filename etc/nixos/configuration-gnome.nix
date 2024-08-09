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
	gnome-photos
	gnome-tour
	gnome-console
	gedit # text editor
  ]) ++ (with pkgs.gnome; [
	cheese # webcam tool
	gnome-music
	gnome-terminal
	epiphany # web browser
	geary # email reader
	evince # document viewer
	gnome-characters
	totem # video player
	tali # poker game
	iagno # go game
	hitori # sudoku game
	atomix # puzzle game
	gnome-weather
	gnome-contacts
	gnome-terminal
	gnome-calendar
	gnome-maps
	gnome-clocks
	simple-scan
  ]);

  environment.systemPackages = [
	pkgs.gnome.gnome-tweaks
	pkgs.gnome-menus

	pkgs.gnome-extension-manager
    pkgs.gnomeExtensions.blur-my-shell
	pkgs.gnomeExtensions.pop-shell
	pkgs.gnomeExtensions.arcmenu
	pkgs.gnomeExtensions.dash-to-panel
	pkgs.gnomeExtensions.wallpaper-slideshow
  ];

  hardware.pulseaudio.enable = false;
}
