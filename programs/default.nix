{ config, pkgs, lib, ... }:
{
	imports = [
		./firefox-custom
		./qs-keyboard
		./qs-lockscreen
		./qs-postcards
		./qs-shell
	];
}
