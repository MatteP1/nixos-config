{ config, pkgs, ... }:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "#ca9ee6";
        separator_color = "#ca9ee6";
        font = "JetBrainsMono Nerd Font 10";
        follow = "keyboard";
        corner_radius = 8;
        offset = "10x10";
      };

      urgency_low = {
        background = "#303446";
        foreground = "#c6d0f5";
        timeout = 7;
      };

      urgency_normal = {
        background = "#303446";
        foreground = "#c6d0f5";
        timeout = 10;
      };

      urgency_critical = {
        background = "#303446";
        foreground = "#e78284";
        frame_color = "#e78284";
        timeout = 40;
      };
    };
  };
}
