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
      echo '{"text": " --°", "tooltip": "Weather unavailable", "class": "disconnected"}'
      exit 0
    fi

    TEMP=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].temp_C')
    FEELS=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].FeelsLikeC')
    DESC=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].weatherDesc[0].value')
    HUMIDITY=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].humidity')
    WIND=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].windspeedKmph')
    AREA=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.nearest_area[0].areaName[0].value')
    CODE=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].weatherCode')

    # Weather icon based on code
    case "$CODE" in
      113) ICON="" ;;            # Clear/Sunny
      116) ICON="" ;;            # Partly cloudy
      119|122) ICON="" ;;        # Cloudy/Overcast
      143|248|260) ICON="" ;;    # Fog/Mist
      176|263|266|293|296|353)
        ICON="" ;;               # Light rain/drizzle
      299|302|305|308|356|359)
        ICON="" ;;               # Heavy rain
      200|386|389|392|395)
        ICON="" ;;               # Thunder
      179|182|185|227|230|281|284|311|314|317|320|323|326|329|332|335|338|350|362|365|368|371|374|377)
        ICON="" ;;               # Snow/sleet/ice
      *)  ICON="" ;;
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
        height = 44;
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
          format = "{index}";
        };

        "niri/window" = {
          format = "{}";
          max-length = 40;
          rewrite = {
            "" = "desktop";
          };
        };

        # ── Center ────────────────────────────────────────

        "mpris" = {
          format = "{status_icon}  {artist} - {title}";
          format-paused = "{status_icon}  <i>{artist} - {title}</i>";
          format-stopped = "";
          max-length = 40;
          status-icons = {
            playing = "";
            paused = "";
          };
          tooltip-format = "{player}: {title}\n{artist} - {album}";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        "clock" = {
          format = "  {:%I:%M %p}";
          format-alt = "  {:%A, %b %d}";
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
          icon-size = 16;
        };

        "network" = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "  off";
          format-alt = "  {essid}";
          tooltip-format-wifi = "{essid}\n{ifname}: {ipaddr}\nStrength: {signalStrength}%";
          tooltip-format-ethernet = "{ifname}: {ipaddr}";
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
          format = "  {volume}%";
          format-muted = "  mute";
          tooltip-format = "{desc}\nVolume: {volume}%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
          scroll-step = 5;
        };

        "custom/power" = {
          format = "";
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

      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }

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
        background: rgba(30, 30, 46, 0.92);
        border: 1px solid rgba(69, 71, 90, 0.5);
        border-radius: 14px;
        padding: 0 4px;
        margin: 4px 0;
      }

      .modules-left   { margin-left:  2px; }
      .modules-right  { margin-right: 2px; }

      /* ── Workspaces ───────────────────────────────────── */
      #workspaces button {
        padding: 0 8px;
        margin: 5px 2px;
        color: #585b70;
        background: transparent;
        border-radius: 8px;
        font-weight: bold;
        font-size: 12px;
        min-width: 20px;
        transition: all 0.3s ease;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #1e1e2e;
        background: #89b4fa;
        min-width: 24px;
      }

      #workspaces button:hover {
        color: #cdd6f4;
        background: rgba(137, 180, 250, 0.25);
      }

      /* ── Window Title ─────────────────────────────────── */
      #window {
        color: #7f849c;
        padding: 0 12px;
        font-style: italic;
      }

      /* ── Clock ────────────────────────────────────────── */
      #clock {
        color: #89b4fa;
        font-weight: bold;
        padding: 0 14px;
      }

      /* ── Media Player ─────────────────────────────────── */
      #mpris {
        color: #a6e3a1;
        padding: 0 12px;
      }

      #mpris.paused {
        color: #585b70;
      }

      /* ── Weather ──────────────────────────────────────── */
      #custom-weather {
        color: #f9e2af;
        padding: 0 12px;
      }

      /* ── Tray ─────────────────────────────────────────── */
      #tray {
        padding: 0 8px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      /* ── Right-side module pills ──────────────────────── */
      /* Each module gets its own colored background pill    */

      #network {
        color: #89dceb;
        background: rgba(137, 220, 235, 0.1);
        border-radius: 10px;
        padding: 0 12px;
        margin: 5px 2px;
      }

      #network.disconnected {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.1);
      }

      #cpu {
        color: #a6e3a1;
        background: rgba(166, 227, 161, 0.1);
        border-radius: 10px;
        padding: 0 12px;
        margin: 5px 2px;
      }

      #cpu.warning {
        color: #f9e2af;
        background: rgba(249, 226, 175, 0.1);
      }

      #cpu.critical {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.15);
      }

      #memory {
        color: #fab387;
        background: rgba(250, 179, 135, 0.1);
        border-radius: 10px;
        padding: 0 12px;
        margin: 5px 2px;
      }

      #memory.warning {
        color: #f9e2af;
        background: rgba(249, 226, 175, 0.1);
      }

      #memory.critical {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.15);
      }

      #pulseaudio {
        color: #cba6f7;
        background: rgba(203, 166, 247, 0.1);
        border-radius: 10px;
        padding: 0 12px;
        margin: 5px 2px;
      }

      #pulseaudio.muted {
        color: #585b70;
        background: rgba(88, 91, 112, 0.1);
      }

      /* ── Power Button ─────────────────────────────────── */
      #custom-power {
        color: #f38ba8;
        padding: 0 12px 0 8px;
        margin: 5px 2px;
        border-radius: 10px;
        font-size: 14px;
        transition: all 0.3s ease;
      }

      #custom-power:hover {
        background: rgba(243, 139, 168, 0.15);
      }

      /* ── Pulse animation for critical states ──────────── */
      @keyframes pulse {
        0%, 100% { opacity: 1; }
        50%      { opacity: 0.5; }
      }

      #cpu.critical,
      #memory.critical {
        animation: pulse 1.5s ease-in-out infinite;
      }
    '';
  };
}
