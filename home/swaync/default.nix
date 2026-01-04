{ config, pkgs, ... }:

{
  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      cssPriority = "user";

      control-center-width = 380;
      control-center-height = 860;
      control-center-margin-top = 2;
      control-center-margin-bottom = 2;
      control-center-margin-right = 1;
      control-center-margin-left = 0;

      notification-window-width = 400;
      notification-icon-size = 48;
      notification-body-image-height = 160;
      notification-body-image-width = 200;

      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      fit-to-screen = false;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = false;
      script-fail-notify = true;

      widgets = [
        "buttons-grid"
        "mpris"
        "volume"
        "backlight"
        "dnd"
        "title"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };

        dnd = {
          text = "Do Not Disturb";
        };

        mpris = {
          image-size = 96;
          image-radius = 12;
          show-album-art = "playing";
          blur = true;
          autohide = true;
        };

        volume = {
          label = "󰕾";
          show-per-app = false;
        };

        backlight = {
          label = "󰃠";
          subsystem = "backlight";
          min = 5;
        };

        buttons-grid = {
          buttons-per-row = 3;
          actions = [
            # Top row
            {
              label = "󰕾";
              type = "toggle";
              command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 || wpctl set-mute @DEFAULT_AUDIO_SINK@ 1'";
              update-command = "wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo false || echo true";
            }
            {
              label = "󰍬";
              type = "toggle";
              command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1'";
              update-command = "wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo false || echo true";
            }
            {
              label = "⏻";
              type = "command";
              command = "wlogout";
            }
            # Bottom row
            {
              label = "󰂯";
              type = "toggle";
              command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && bluetoothctl power on || bluetoothctl power off'";
              update-command = "bluetoothctl show | grep -q 'Powered: yes' && echo true || echo false";
            }
            {
              label = "󰤨";
              type = "toggle";
              command = "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'";
              update-command = "nmcli radio wifi | grep -q enabled && echo true || echo false";
            }
            {
              label = "󰒓";
              type = "command";
              command = "kitty -e nvim ~/nixos-config";
            }
          ];
        };
      };
    };

    style = ./style.css;
  };

  # Install required packages
  home.packages = with pkgs; [
    swaynotificationcenter
    wlogout
    kitty
  ];
}
