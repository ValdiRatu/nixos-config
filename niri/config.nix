{
  config,
  ...
}:
{
  programs.niri.settings = {
    environment = {
      NIXOS_OZONE_WL = "1"; # Electron apps
      QT_QPA_PLATFORM = "wayland"; # Qt apps
    };

    spawn-at-startup = [
      { argv = [ "xwayland-satellite" ]; }
      # waybar is started via programs.waybar.systemd in waybar.nix
      { argv = [ "mako" ]; }
      {
        argv = [
          "swaybg"
          "-m"
          "fill"
          "-c"
          "#1a1a2e"
        ];
      }
    ];

    layout = {
      gaps = 12;
      center-focused-column = "on-overflow";
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];
      default-column-width = {
        proportion = 0.5;
      };
      focus-ring = {
        enable = true;
        width = 4;
        active.color = "#7fc8ff";
        inactive.color = "#404040";
      };
    };

    prefer-no-csd = true;
  };
}
