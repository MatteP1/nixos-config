{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [
      {
        layer = "top";
        height = 34;

        modules-left = [
          "hyprland/workspaces"
          "niri/workspaces"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "bluetooth"
          "battery"
          "network"
          "wireplumber"
          "tray"
        ];

        # ----------------------
        # Hyprland workspaces
        # ----------------------
        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            active = "";
            default = "";
          };
        };

        # ----------------------
        # Niri workspaces
        # ----------------------
        "niri/workspaces" = {
          format = "{index}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            active = "";
            default = "";
          };
        };

        # ----------------------
        # Clock (center)
        # ----------------------
        clock = {
          calendar = {
            mode = "month";
          };
          format = "{:%a %d %b, %H:%M}";
          interval = 10;
          tooltip-format = "<span font='JetBrainsMono Nerd Font'>{calendar}</span>";
        };

        # ----------------------
        # Bluetooth
        # ----------------------
        bluetooth = {
          format = "";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          on-click = "blueberry";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };

        # ----------------------
        # Battery
        # ----------------------
        battery = {
          format = "{icon}";
          format-charging = "";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          interval = 5;
          max-length = 25;
          states = {
            critical = 15;
            warning = 30;
          };
          tooltip-format = "{capacity}% {time}";
          tooltip-format-charging = "{capacity}%  {timeTo}";
        };

        # ----------------------
        # Network
        # ----------------------
        network = {
          format = " {ifname}";
          format-disconnected = "";
          format-icons = [
            ""
            ""
            ""
            ""
          ];
          format-wifi = "{icon} {essid}";
          max-length = 50;
          on-click = "nm-connection-editor";
          tooltip-format = "@ {ipaddr}\n {bandwidthDownBytes}  {bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          tooltip-format-wifi = "@ {ipaddr}\n {frequency}\n {bandwidthDownBytes}  {bandwidthUpBytes}";
        };

        # ----------------------
        # Wireplumber (audio)
        # ----------------------
        wireplumber = {
          format = "{icon} {volume}%";
          format-icons = [
            ""
            ""
            ""
          ];
          format-muted = " {volume}%";
          max-volume = 150;
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 5;
        };

        # ----------------------
        # Tray
        # ----------------------
        tray = {
          icon-size = 15;
          spacing = 10;
        };
      }
    ];

    style = ./style.css;

    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };

  home.packages = with pkgs; [
    blueberry
    networkmanagerapplet
  ];
}
