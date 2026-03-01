{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };
}
