{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    # themeFile = "Catppuccin-Mocha";
    shellIntegration.enableFishIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      dynamic_background_opacity = true;
      font_family = "FiraCode Nerd Font";
      font_size = "11";
      background_opacity = "0.7";
      shell = "fish";
      editor = "nvim";
    };
  };
}
