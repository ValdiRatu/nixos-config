{ pkgs, ... }:
let
  # ╔══════════════════════════════════════════════════════╗
  # ║  SWITCH STYLE HERE — change to neon.nix or           ║
  # ║  minimal.nix for a completely different look         ║
  # ╚══════════════════════════════════════════════════════╝
  style = import ./waybar-styles/minimal.nix;

  # ── Icon definitions ─────────────────────────────────
  # Using verified Nerd Font codepoints (Material Design Icons range)
  # Reference: https://www.nerdfonts.com/cheat-sheet
  icons = {
    clock     = "󰥔"; # nf-md-clock_outline        U+F0954
    calendar  = "󰃭"; # nf-md-calendar             U+F00ED
    cpu       = "󰍛"; # nf-md-chip                 U+F035B
    memory    = "󰘚"; # nf-md-memory               U+F061A
    wifi      = "󰖩"; # nf-md-wifi                 U+F05A9
    ethernet  = "󰈀"; # nf-md-ethernet             U+F0200
    wifi_off  = "󰖪"; # nf-md-wifi_off             U+F05AA
    vol_high  = "󰕾"; # nf-md-volume_high          U+F057E
    vol_med   = "󰖀"; # nf-md-volume_medium        U+F0580
    vol_low   = "󰕿"; # nf-md-volume_low           U+F057F
    vol_mute  = "󰝟"; # nf-md-volume_off           U+F075F
    play      = "󰐊"; # nf-md-play                 U+F040A
    pause     = "󰏤"; # nf-md-pause                U+F03E4
    power     = "󰐥"; # nf-md-power                U+F0425
    weather   = "󰖙"; # nf-md-weather_partly_cloudy U+F0599
    bat_full  = "󰁹"; # nf-md-battery              U+F0079
    bat_high  = "󰂀"; # nf-md-battery_80           U+F0080
    bat_med   = "󰁾"; # nf-md-battery_60           U+F007E
    bat_low   = "󰁼"; # nf-md-battery_40           U+F007C
    bat_empty = "󰁺"; # nf-md-battery_10           U+F007A
    bat_chg   = "󰂄"; # nf-md-battery_charging     U+F0084
  };

  # ── Weather script ───────────────────────────────────
  weather-script = pkgs.writeShellScriptBin "waybar-weather" ''
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
      echo '{"text": "${icons.weather} --", "tooltip": "Weather unavailable"}'
      exit 0
    fi

    TEMP=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].temp_C')
    FEELS=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].FeelsLikeC')
    DESC=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].weatherDesc[0].value')
    HUMIDITY=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].humidity')
    WIND=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].windspeedKmph')
    AREA=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.nearest_area[0].areaName[0].value')
    CODE=$(echo "$DATA" | ${pkgs.jq}/bin/jq -r '.current_condition[0].weatherCode')

    case "$CODE" in
      113) ICON="󰖙" ;;
      116) ICON="󰖐" ;;
      119|122) ICON="󰖐" ;;
      143|248|260) ICON="󰖑" ;;
      176|263|266|293|296|353) ICON="󰖗" ;;
      299|302|305|308|356|359) ICON="󰖖" ;;
      200|386|389|392|395) ICON="󰖓" ;;
      *) ICON="󰖙" ;;
    esac

    TOOLTIP="$DESC in $AREA\nFeels like ''${FEELS}°C · Humidity ''${HUMIDITY}%\nWind ''${WIND} km/h"
    RESULT="{\"text\": \"$ICON ''${TEMP}°\", \"tooltip\": \"$TOOLTIP\"}"

    echo "$RESULT" > "$CACHE"
    echo "$RESULT"
  '';

  # ── Power menu script ────────────────────────────────
  power-menu = pkgs.writeShellScriptBin "waybar-power-menu" ''
    CHOICE=$(printf "󰌾  Lock\n󰗼  Logout\n󰜉  Reboot\n󰐥  Shutdown\n󰤄  Suspend" | \
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
        margin-top = 4;
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
          "battery"
          "pulseaudio"
          "custom/power"
        ];

        # ── Left ─────────────────────────────────────

        "niri/workspaces" = {
          format = "{index}";
        };

        "niri/window" = {
          format = "{}";
          max-length = 30;
          rewrite = {
            "" = "";
          };
        };

        # ── Center ───────────────────────────────────

        "mpris" = {
          format = "${icons.play} {artist} - {title}";
          format-paused = "${icons.pause} <i>{artist} - {title}</i>";
          format-stopped = "";
          max-length = 40;
          status-icons = {
            playing = icons.play;
            paused = icons.pause;
          };
          tooltip-format = "{player}: {title}\n{artist} - {album}";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl next";
          on-scroll-down = "playerctl previous";
        };

        "clock" = {
          format = "{:%I:%M}";
          format-alt = "{:%A, %b %d}";
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

        # ── Right ────────────────────────────────────

        "tray" = {
          spacing = 8;
          icon-size = 16;
        };

        "network" = {
          format-wifi = "${icons.wifi}";
          format-ethernet = "${icons.ethernet}";
          format-disconnected = "${icons.wifi_off}";
          format-alt = "${icons.wifi} {essid} {signalStrength}%";
          tooltip-format-wifi = "{essid}\n{ifname}: {ipaddr}\nStrength: {signalStrength}%";
          tooltip-format-ethernet = "{ifname}: {ipaddr}";
          tooltip-format-disconnected = "No connection";
          interval = 5;
          on-click = "nm-connection-editor";
          on-click-right = "ghostty -e nmtui";
        };

        "cpu" = {
          format = "${icons.cpu} {usage}";
          interval = 3;
          tooltip-format = "CPU: {usage}%\n{avg_frequency} GHz";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "memory" = {
          format = "${icons.memory} {percentage}";
          interval = 5;
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "battery" = {
          interval = 30;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}";
          format-charging = "${icons.bat_chg} {capacity}";
          format-full = "${icons.bat_full}";
          format-icons = [
            icons.bat_empty
            icons.bat_low
            icons.bat_med
            icons.bat_high
            icons.bat_full
          ];
          tooltip-format = "{timeTo}\nCycles: {cycles}\nHealth: {health}%";
        };

        "pulseaudio" = {
          format = "{icon} {volume}";
          format-muted = "${icons.vol_mute}";
          format-icons = {
            default = [
              icons.vol_low
              icons.vol_med
              icons.vol_high
            ];
          };
          tooltip-format = "{desc}\nVolume: {volume}%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pavucontrol";
          scroll-step = 5;
        };

        "custom/power" = {
          format = icons.power;
          tooltip = false;
          on-click = "waybar-power-menu";
        };
      };
    };

    style = style;
  };
}
