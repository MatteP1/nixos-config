{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 10;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/clipboard"
          "pulseaudio"
          "pulseaudio#microphone"
          "bluetooth"
          "network"
          "battery"
          "custom/power"
        ];

        # Workspaces with Japanese numerals
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          persistent-workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
          };
          all-outputs = true;
          disable-scroll = true;
          # active-only = false;
        };

        # Clock with custom icon
        clock = {
          format = "{:%A, %B %d  󰥔 %H:%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ff79c6'><b>{}</b></span>";
              days = "<span color='#f8f8f2'><b>{}</b></span>";
              weeks = "<span color='#bd93f9'><b>W{}</b></span>";
              weekdays = "<span color='#ffb86c'><b>{}</b></span>";
              today = "<span color='#ff5555'><b><u>{}</u></b></span>";
            };
          };
        };

        # Clipboard
        "custom/clipboard" = {
          format = "󰅇";
          tooltip = false;
          on-click = "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
        };

        # Audio Output
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          scroll-step = 5;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
        };

        # Microphone
        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-click-right = "pavucontrol -t 4";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
        };

        # Bluetooth
        bluetooth = {
          format = "󰂯 {status}";
          format-disabled = "󰂲 {status}";
          format-connected = "󰂱 {num_connections}";
          format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t󰥉 {device_battery_percentage}%";
          on-click = "blueman-manager";
          on-click-right = "blueman-manager";
        };

        # Network
        network = {
          format-wifi = "{icon} {essid}";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰤭 Disconnected";
          format-icons = {
            wifi = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
          };
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) {icon} {ipaddr}";
          on-click = "nm-connection-editor";
        };

        # Battery
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{timeTo}, {capacity}%";
        };

        # Power menu
        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };

    style = ./waybar-style.css;
  };

  # Optional: Install required packages
  home.packages = with pkgs; [
    pavucontrol
    blueman
    networkmanagerapplet
    wlogout
    cliphist
    fuzzel
    wl-clipboard
  ];
}
