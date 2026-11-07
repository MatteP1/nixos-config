{ pkgs, lib, ... }:
{

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = lib.mkMerge [
      (fromTOML (builtins.readFile "${pkgs.starship}/share/starship/presets/catppuccin-powerline.toml"))
    ];
  };
}
