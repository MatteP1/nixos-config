{ pkgs, ... }:

{
  imports = [
    ./dms.nix
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    iosevka
    font-awesome
    material-design-icons
  ];

  programs.niri.enable = true;
}
