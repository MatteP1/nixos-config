{ config, pkgs, ... }:

{
  home.username = "matte";
  home.homeDirectory = "/home/matte";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  imports = [
    ./fcitx5.nix
  ];

}


