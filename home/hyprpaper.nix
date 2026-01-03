{
  config,
  pkgs,
  ...
}:

# let
#   wallpaper = "${config.home.homeDirectory}/nixos-config/assets/kimi_no_na_wa_machi.jpeg";
# in
{
  home.packages = [
    pkgs.hyprpaper
  ];
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = true;
      # preload = [ wallpaper ];
      # wallpaper = [ ",${wallpaper}" ];
    };
  };
}
