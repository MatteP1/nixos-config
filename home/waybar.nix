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
          "pulseaudio"
          "bluetooth"
          "network"
          "battery"
          "custom/power"
        ];

        # Workspaces
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        # Clock
        clock = {
          format = "{:%A, %B %d  %H:%M}";
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

        # Audio
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };

        # Bluetooth
        bluetooth = {
          format = " {status}";
          format-disabled = "";
          format-connected = " {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        # Network
        network = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰖪 Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)  {ipaddr}";
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
          format-plugged = "󰂄 {capacity}%";
          format-icons = [
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

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      /* Island styling */
      #workspaces,
      #clock,
      #pulseaudio,
      #bluetooth,
      #network,
      #battery,
      #custom-power {
        background: rgba(40, 40, 40, 0.95);
        padding: 5px 15px;
        margin: 5px 0;
        border-radius: 10px;
        border: 1px solid rgba(255, 255, 255, 0.1);
      }

      /* Left island (workspaces) */
      #workspaces {
        margin-left: 10px;
        padding: 0 5px;
      }

      #workspaces button {
        padding: 5px 10px;
        color: #f8f8f2;
        background: transparent;
        border-radius: 8px;
        margin: 0 2px;
      }

      #workspaces button:hover {
        background: rgba(255, 121, 198, 0.2);
        color: #ff79c6;
      }

      #workspaces button.active {
        background: #ff79c6;
        color: #282a36;
      }

      #workspaces button.urgent {
        background: #ff5555;
        color: #282a36;
      }

      /* Center island (clock) */
      #clock {
        color: #ff79c6;
        font-weight: bold;
      }

      /* Right islands (hardware) */
      #pulseaudio,
      #bluetooth,
      #network,
      #battery,
      #custom-power {
        margin-right: 5px;
      }

      #custom-power {
        margin-right: 10px;
      }

      #pulseaudio {
        color: #ff79c6;
      }

      #bluetooth {
        color: #ff79c6;
      }

      #bluetooth.disabled {
        color: #6272a4;
      }

      #network {
        color: #ff79c6;
      }

      #network.disconnected {
        color: #ff5555;
      }

      #battery {
        color: #ff79c6;
      }

      #battery.warning {
        color: #ffb86c;
      }

      #battery.critical {
        color: #ff5555;
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          opacity: 0.5;
        }
      }

      #custom-power {
        color: #ff79c6;
        font-size: 16px;
        padding: 5px 12px;
      }

      #custom-power:hover {
        background: rgba(255, 121, 198, 0.3);
      }

      /* Tooltips */
      tooltip {
        background: rgba(40, 40, 40, 0.95);
        border: 1px solid #ff79c6;
        border-radius: 8px;
      }

      tooltip label {
        color: #f8f8f2;
      }
    '';
  };

  # Optional: Install required packages
  home.packages = with pkgs; [
    pavucontrol
    blueman
    networkmanagerapplet
    wlogout
  ];
}
