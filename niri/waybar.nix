{ pkgs, ... }:
let
  # Weather script — fetches current conditions from wttr.in
  weather-script = pkgs.writeShellScriptBin "waybar-weather" ''
    # Cache weather for 10 minutes to avoid hammering the API
    CACHE="$HOME/.cache/waybar-weather.json"
    CACHE_AGE=600

    if [ -f "$CACHE" ]; then
      AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE") ))
      if [ "$AGE" -lt "$CACHE_AGE" ]; then
        cat "$CACHE"
        exit 0
      fi
    fi

    mkdir -p "$(dirname "$CACHE")"

    DATA=$(${pkgs.curl}/bin/curl -sf "wttr.in/?format=j1" 2>/dev/null)

    if [ -z "$DATA" ]; then
      echo '{"text": "  --", "tooltip": "Weather unavailable", "class": "disconnected"}'
      exit 0
    fi

    TEMP=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].temp_C')
    FEELS=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].FeelsLikeC')
    DESC=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].weatherDesc[0].value')
    HUMIDITY=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].humidity')
    WIND=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].windspeedKmph')
    AREA=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.nearest_area[0].areaName[0].value')

    # Weather icon based on description
    case "$(echo "$DESC" | tr '[:upper:]' '[:lower:]')" in
      *clear*|*sunny*)  ICON="" ;;
      *partly*|*cloud*) ICON="" ;;
      *overcast*)       ICON="" ;;
      *rain*|*drizzle*) ICON="" ;;
      *thunder*)        ICON="" ;;
      *snow*)           ICON="" ;;
      *fog*|*mist*)     ICON="" ;;
      *)                ICON="" ;;
    esac

    TOOLTIP="$DESC in $AREA\nFeels like ''${FEELS}°C\nHumidity: ''${HUMIDITY}%\nWind: ''${WIND} km/h"
    RESULT="{\"text\": \"$ICON ''${TEMP}°\", \"tooltip\": \"$TOOLTIP\"}"

    echo "$RESULT" > "$CACHE"
    echo "$RESULT"
  '';

  # Power menu script — uses fuzzel for a clean session menu
  power-menu = pkgs.writeShellScriptBin "waybar-power-menu" ''
    CHOICE=$(printf "  Lock\n  Logout\n  Reboot\n  Shutdown\n  Suspend" | \
      ${pkgs.fuzzel}/bin/fuzzel --dmenu --prompt "  " --width 18 --lines 5)

    case "$CHOICE" in
      *Lock*)     ${pkgs.swaylock}/bin/swaylock ;;
      *Logout*)   niri msg action quit ;;
      *Reboot*)   systemctl reboot ;;
      *Shutdown*) systemctl poweroff ;;
      *Suspend*)  systemctl suspend ;;
    esac
  '';
in
{
  home.packages = [
    weather-script
    power-menu
  ];

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
        height = 40;
        margin-top = 6;
        margin-left = 8;
        margin-right = 8;
        spacing = 0;

        modules-left = [
          "niri/workspaces"
          "niri/window"
        ];

        modules-center = [
          "mpris"
          "clock"
          "custom/weather"
        ];

        modules-right = [
          "tray"
          "network"
          "cpu"
          "memory"
          "pulseaudio"
          "custom/power"
        ];

        # ── Left ──────────────────────────────────────────

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        "niri/window" = {
          format = "{}";
          max-length = 40;
          rewrite = {
            "" = " desktop";
          };
        };

        # ── Center ────────────────────────────────────────

        "mpris" = {
          format = "{status_icon} {artist} — {title}";
          format-paused = "{status_icon} <i>{artist} — {title}</i>";
          format-stopped = "";
          max-length = 45;
          status-icons = {
            playing = "󰐊";
            paused = "󰏤";
          };
          tooltip-format = "{player}: {title}\n{artist} · {album}";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        "clock" = {
          format = "  {:%H:%M}";
          format-alt = "  {:%A, %B %d}";
          tooltip-format = "<big>{:%B %Y}</big>\n<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            weeks-pos = "left";
            format = {
              months = "<span color='#f5e0dc'><b>{}</b></span>";
              weeks = "<span color='#94e2d5'><b>W{}</b></span>";
              weekdays = "<span color='#cba6f7'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
        };

        "custom/weather" = {
          exec = "waybar-weather";
          return-type = "json";
          interval = 600;
          tooltip = true;
        };

        # ── Right ─────────────────────────────────────────

        "tray" = {
          spacing = 8;
          icon-size = 15;
        };

        "network" = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀  connected";
          format-disconnected = "󰖪  off";
          format-alt = "  {essid}  ·  {ipaddr}";
          tooltip-format-wifi = "{essid}\n{ifname}: {ipaddr}\nStrength: {signalStrength}%\n⬇ {bandwidthDownBytes}  ⬆ {bandwidthUpBytes}";
          tooltip-format-ethernet = "{ifname}: {ipaddr}\n⬇ {bandwidthDownBytes}  ⬆ {bandwidthUpBytes}";
          tooltip-format-disconnected = "No connection";
          interval = 5;
          on-click = "nm-connection-editor";
          on-click-right = "ghostty -e nmtui";
        };

        "cpu" = {
          format = "  {usage}%";
          interval = 3;
          tooltip-format = "CPU: {usage}%\n{avg_frequency} GHz";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "memory" = {
          format = "  {percentage}%";
          interval = 5;
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-muted = "󰖁  muted";
          format-icons = {
            headphone = "󰋋";
            default = [ "" "" "󰕾" "" ];
          };
          tooltip-format = "{desc}\nVolume: {volume}%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
          scroll-step = 5;
        };

        "custom/power" = {
          format = "⏻";
          tooltip = false;
          on-click = "waybar-power-menu";
        };
      };
    };

    style = ''
      /* ── Base ─────────────────────────────────────────── */
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      /* Transparent bar — the islands provide their own bg */
      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }

      /* Prevent tooltip clipping */
      tooltip {
        background: #1e1e2e;
        border: 1px solid #45475a;
        border-radius: 10px;
        color: #cdd6f4;
      }

      tooltip label {
        color: #cdd6f4;
        padding: 4px 2px;
      }

      /* ── Floating Islands ─────────────────────────────── */
      .modules-left,
      .modules-center,
      .modules-right {
        background: rgba(30, 30, 46, 0.85);
        border: 1px solid rgba(69, 71, 90, 0.6);
        border-radius: 14px;
        padding: 0 6px;
        margin: 4px 0;
      }

      /* Subtle shadow via border glow */
      .modules-left   { margin-left:  2px; }
      .modules-right  { margin-right: 2px; }

      /* ── All Modules — shared base ────────────────────── */
      #workspaces,
      #window,
      #mpris,
      #clock,
      #custom-weather,
      #tray,
      #network,
      #cpu,
      #memory,
      #pulseaudio,
      #custom-power {
        padding: 0 10px;
        transition: all 0.3s ease;
      }

      /* ── Workspaces ───────────────────────────────────── */
      #workspaces button {
        padding: 0 5px;
        margin: 4px 1px;
        color: #585b70;
        background: transparent;
        border-radius: 10px;
        transition: all 0.3s ease;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #89b4fa;
        background: rgba(137, 180, 250, 0.12);
        min-width: 24px;
      }

      #workspaces button:hover {
        color: #b4befe;
        background: rgba(180, 190, 254, 0.1);
      }

      /* ── Window ───────────────────────────────────────── */
      #window {
        color: #a6adc8;
        font-style: italic;
      }

      /* ── Clock ────────────────────────────────────────── */
      #clock {
        color: #89b4fa;
        font-weight: bold;
      }

      #clock:hover {
        color: #b4befe;
      }

      /* ── Media Player ─────────────────────────────────── */
      #mpris {
        color: #a6e3a1;
      }

      #mpris.paused {
        color: #6c7086;
      }

      #mpris:hover {
        color: #94e2d5;
      }

      /* ── Weather ──────────────────────────────────────── */
      #custom-weather {
        color: #f9e2af;
      }

      /* ── Tray ─────────────────────────────────────────── */
      #tray {
        padding: 0 6px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: rgba(243, 139, 168, 0.3);
        border-radius: 8px;
      }

      /* ── Network ──────────────────────────────────────── */
      #network {
        color: #89dceb;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #network:hover {
        color: #74c7ec;
      }

      /* ── CPU ──────────────────────────────────────────── */
      #cpu {
        color: #a6e3a1;
      }

      #cpu.warning {
        color: #f9e2af;
      }

      #cpu.critical {
        color: #f38ba8;
      }

      /* ── Memory ───────────────────────────────────────── */
      #memory {
        color: #fab387;
      }

      #memory.warning {
        color: #f9e2af;
      }

      #memory.critical {
        color: #f38ba8;
      }

      /* ── Audio ─────────────────────────────────────────── */
      #pulseaudio {
        color: #cba6f7;
      }

      #pulseaudio.muted {
        color: #585b70;
      }

      #pulseaudio:hover {
        color: #b4befe;
      }

      /* ── Power ─────────────────────────────────────────── */
      #custom-power {
        color: #f38ba8;
        font-size: 15px;
        padding: 0 12px 0 8px;
      }

      #custom-power:hover {
        color: #eba0ac;
        text-shadow: 0 0 8px rgba(243, 139, 168, 0.6);
      }

      /* ── Module separator — thin vertical line ─────────── */
      #cpu,
      #memory,
      #pulseaudio,
      #custom-weather,
      #network {
        border-left: 1px solid rgba(88, 91, 112, 0.4);
        margin-top: 6px;
        margin-bottom: 6px;
      }
    '';
  };
}
