{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    xdg-utils
    xdg-desktop-portal-gtk
    adwaita-icon-theme
    brightnessctl
    waypaper
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
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

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  home.file.".config/niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "/home/matte/nixos-config/home/niri/config.kdl";

}
