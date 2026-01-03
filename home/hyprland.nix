{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    dunst
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

  # wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    bind = [
      "$mod, Q, exec, kitty"
      "$mod, R, exec, fuzzel"
    ];
  };
  home.file.".config/hypr".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/hypr";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.hyprland ];
  };

  services.hyprpolkitagent.enable = true;

}
