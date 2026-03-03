{
  config,
  ...
}:
{
  programs.niri.settings.binds = with config.lib.niri.actions; {
    # Apps
    "Mod+T".action = spawn "alacritty";
    "Mod+Space".action = spawn "fuzzel";
    "Super+Alt+L".action = spawn "swaylock";
    "Mod+W".action = spawn "niri-window-picker";

    # Window management
    "Mod+Q".action = close-window;
    "Mod+V".action = toggle-window-floating;
    "Mod+Shift+F".action = fullscreen-window;
    "Mod+F".action = maximize-column;
    "Mod+C".action = center-column;

    # Focus movement
    "Mod+H".action = focus-column-left;
    "Mod+L".action = focus-column-right;
    "Mod+K".action = focus-window-up;
    "Mod+J".action = focus-window-down;
    "Mod+Left".action = focus-column-left;
    "Mod+Right".action = focus-column-right;
    "Mod+Up".action = focus-window-up;
    "Mod+Down".action = focus-window-down;

    # Move windows
    "Mod+Ctrl+H".action = move-column-left;
    "Mod+Ctrl+L".action = move-column-right;
    "Mod+Ctrl+K".action = move-window-up;
    "Mod+Ctrl+J".action = move-window-down;
    "Mod+Ctrl+Left".action = move-column-left;
    "Mod+Ctrl+Right".action = move-column-right;
    "Mod+Ctrl+Up".action = move-window-up;
    "Mod+Ctrl+Down".action = move-window-down;

    # Column width
    "Mod+R".action = switch-preset-column-width;
    "Mod+Minus".action = set-column-width "-10%";
    "Mod+Equal".action = set-column-width "+10%";

    # Workspaces
    "Mod+U".action = focus-workspace-down;
    "Mod+I".action = focus-workspace-up;
    "Mod+Ctrl+U".action = move-column-to-workspace-down;
    "Mod+Ctrl+I".action = move-column-to-workspace-up;

    # Screenshots — access hyphenated actions directly to avoid scope issues
    # not working for some reason :(
    # "Print".action = screenshot;
    # "Ctrl+Print".action = config.lib.niri.actions."screenshot-screen";
    # "Alt+Print".action = config.lib.niri.actions."screenshot-window";

    # Volume keys
    "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
    "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
    "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";

    # Exit
    "Mod+Shift+E".action = quit;
  };
}
