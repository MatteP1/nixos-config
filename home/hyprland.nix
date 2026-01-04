{ pkgs, config, ... }:
{
  imports = [
    ./fuzzel.nix
    # ./dunst.nix
    ./swaync
    ./waybar
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [
    xdg-utils
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    adwaita-icon-theme
    waypaper
    hyprpicker
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  services.cliphist.enable = true;

  wayland.windowManager.hyprland = {
    # enable = true;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Q, exec, kitty"
        "$mod, R, exec, fuzzel"
      ];
    };
  };

  home.file.".config/hypr/hyprland.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/hypr/hyprland.conf";
  home.file.".config/hypr/known-monitors.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/hypr/known-monitors.conf";
  home.file.".config/hypr/monitors.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home/hypr/monitors.conf";

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.hyprland ];
  };

  services.hyprpolkitagent.enable = true;

  programs.hyprlock.enable = true;

}
