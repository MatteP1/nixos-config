{ config, pkgs, ... }:
{
  imports = [
    ./dms.nix
  ];
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
