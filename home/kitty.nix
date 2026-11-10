{ pkgs, config, ... }:
{
  programs.kitty = {
    enable = true;
    # Comes from the Homebrew cask on Darwin instead (modules/darwin/common.nix).
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.kitty;
    # themeFile = "Catppuccin-Mocha";
    shellIntegration.enableFishIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      cursor_shape = "block";
      cursor_trail = 1;
      scrollback_lines = 100000;
      strip_trailing_spaces = "smart";
      dynamic_background_opacity = true;
      font_family = "FiraCode Nerd Font";
      font_size = "11";
      background_opacity = "0.7";
      shell = "${pkgs.fish}/bin/fish";
      editor = "${config.programs.neovim.finalPackage}/bin/nvim";
    };

    extraConfig = ''
      include dank-tabs.conf
      include dank-theme.conf
    '';

    keybindings = {
      "kitty_mod+0" = "change_font_size all 0";
      "kitty_mod+=" = "change_font_size all +1";
      "kitty_mod+-" = "change_font_size all -1";
      "kitty_mod+с" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
    };
  };
}
