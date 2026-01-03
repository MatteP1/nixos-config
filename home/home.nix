{ config, pkgs, ... }:

{
  home.username = "matte";
  home.homeDirectory = "/home/matte";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  imports = [
    ./kitty.nix
    ./starship.nix
    ./neovim.nix
    ./fcitx5.nix
    ./ssh.nix
    ./git.nix
    ./opam.nix
    ./hyprland.nix
    ./waybar
    ./fuzzel.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    prismlauncher
    spotify
    nautilus
  ];

  programs.fish.enable = true;

}
