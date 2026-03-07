{ ... }:
{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "niri.service";
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;

        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "tray"
          "network"
          "cpu"
          "memory"
          "pulseaudio"
        ];

        # --- Left modules ---

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "●";
            default = "○";
          };
        };

        "niri/window" = {
          format = "{title}";
          max-length = 50;
        };

        # --- Center modules ---

        "clock" = {
          format = " {:%H:%M}";
          format-alt = " {:%A, %B %d, %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        # --- Right modules ---

        "tray" = {
          spacing = 8;
          icon-size = 16;
        };

        "network" = {
          format-wifi = "{essid} {signalStrength}%";
          format-ethernet = " connected";
          format-disconnected = "󰖪 disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{ifname}: {ipaddr}\n{essid} ({signalStrength}%)";
          on-click = "nm-connection-editor";
          on-click-right = "ghostty -e nmtui";
        };

        "cpu" = {
          format = " {usage}%";
          interval = 2;
          tooltip = false;
        };

        "memory" = {
          format = " {percentage}%";
          interval = 2;
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 muted";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 5;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: #1a1a2e;
        color: #cdd6f4;
      }

      /* Left section */
      .modules-left {
        padding-left: 8px;
      }

      /* Right section */
      .modules-right {
        padding-right: 8px;
      }

      /* Workspaces */
      #workspaces button {
        padding: 0 6px;
        color: #6c7086;
        background: transparent;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #7fc8ff;
      }

      #workspaces button:hover {
        color: #cdd6f4;
        background: rgba(255, 255, 255, 0.1);
      }

      /* Window title */
      #window {
        color: #cdd6f4;
        padding: 0 8px;
      }

      /* Clock */
      #clock {
        color: #7fc8ff;
        font-weight: bold;
        padding: 0 8px;
      }

      /* All right-side modules share base style */
      #tray,
      #network,
      #cpu,
      #memory,
      #pulseaudio {
        padding: 0 8px;
        color: #cdd6f4;
      }

      #cpu {
        color: #a6e3a1;
      }

      #memory {
        color: #fab387;
      }

      #network {
        color: #89dceb;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #cba6f7;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
      }
    '';
  };
}
