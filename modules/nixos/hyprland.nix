{ config, pkgs, ... }:
{
  imports = [
    ./dux.nix
  ];
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
