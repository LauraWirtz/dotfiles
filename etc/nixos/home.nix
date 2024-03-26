{
  home.username = "laura";
  home.homeDirectory = "/home/laura";

  programs.home-manager.enable = true;
  programs.bash.enable = true;
    programs.git = {
    enable = true;
    userName  = "LauraWirtz";
    userEmail = "lw.laura.wirtz@gmail.com";
    aliases = {
      cam = "commit -a -m";
    };
  };

  home.stateVersion = "23.11";
}
