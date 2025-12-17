{ config, pkgs, ... }:

{
  home.username = "matte";
  home.homeDirectory = "/home/matte";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports = [
    ./fcitx5.nix
    ./ssh.nix
    ./git.nix
  ];

  home.packages = with pkgs; [
    spotify
  ];

}


