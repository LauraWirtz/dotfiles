{ config, pkgs, lib, ... }:
{
	imports = [
		./qs-keyboard
		./qs-lockscreen
		./qs-postcards
		./qs-shell
	];
}
