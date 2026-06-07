{ config, pkgs, lib, ... }:
{
	imports = [
		./qs-lockscreen
		./qs-postcards
		./qs-shell
	];
}
