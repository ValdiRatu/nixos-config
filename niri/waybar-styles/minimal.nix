# Minimal — Clean, understated, monochrome with a single warm accent
# Thin bar, no backgrounds on modules, just clean typography and spacing
''
  /* ── Base ──────────────────────────────────────── */
  * {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 12px;
    min-height: 0;
    border: none;
    border-radius: 0;
  }

  window#waybar {
    background: transparent;
    color: #908caa;
  }

  tooltip {
    background: rgba(25, 23, 36, 0.95);
    border: 1px solid rgba(110, 106, 134, 0.3);
    border-radius: 8px;
    color: #e0def4;
  }

  tooltip label {
    color: #e0def4;
    padding: 4px 2px;
  }

  /* ── Floating Islands ─────────────────────────── */
  .modules-left,
  .modules-center,
  .modules-right {
    background: rgba(25, 23, 36, 0.75);
    border: none;
    border-radius: 12px;
    padding: 0 8px;
    margin: 5px 0;
  }

  .modules-left   { margin-left:  2px; }
  .modules-right  { margin-right: 2px; }

  /* ── Workspaces ────────────────────────────────── */
  #workspaces button {
    padding: 0 6px;
    margin: 6px 1px;
    color: #44415a;
    background: transparent;
    border-radius: 6px;
    font-weight: bold;
    font-size: 11px;
    transition: all 0.3s ease;
  }

  #workspaces button.active,
  #workspaces button.focused {
    color: #e0def4;
    background: rgba(224, 222, 244, 0.08);
  }

  #workspaces button:hover {
    color: #908caa;
  }

  /* ── Window Title ──────────────────────────────── */
  #window {
    color: #6e6a86;
    padding: 0 10px;
  }

  /* ── Clock ─────────────────────────────────────── */
  #clock {
    color: #e0def4;
    font-weight: bold;
    padding: 0 14px;
  }

  /* ── Media Player ──────────────────────────────── */
  #mpris {
    color: #9ccfd8;
    padding: 0 10px;
  }

  #mpris.paused {
    color: #44415a;
  }

  /* ── Weather ───────────────────────────────────── */
  #custom-weather {
    color: #f6c177;
    padding: 0 10px;
  }

  /* ── Tray ──────────────────────────────────────── */
  #tray {
    padding: 0 6px;
  }

  #tray > .passive {
    -gtk-icon-effect: dim;
  }

  /* ── Right modules — clean, no pills ───────────── */
  #network,
  #cpu,
  #memory,
  #pulseaudio {
    padding: 0 10px;
    margin: 5px 0;
    transition: all 0.3s ease;
  }

  #network       { color: #908caa; }
  #network:hover { color: #e0def4; }
  #network.disconnected { color: #eb6f92; }

  #cpu       { color: #908caa; }
  #cpu:hover { color: #e0def4; }

  #cpu.warning  { color: #f6c177; }
  #cpu.critical { color: #eb6f92; }

  #memory       { color: #908caa; }
  #memory:hover { color: #e0def4; }

  #memory.warning  { color: #f6c177; }
  #memory.critical { color: #eb6f92; }

  #pulseaudio       { color: #908caa; }
  #pulseaudio:hover { color: #e0def4; }
  #pulseaudio.muted { color: #44415a; }

  /* ── Separator dots between right modules ──────── */
  #cpu,
  #memory,
  #pulseaudio {
    border-left: 1px solid rgba(110, 106, 134, 0.2);
  }

  /* ── Power Button ──────────────────────────────── */
  #custom-power {
    color: #6e6a86;
    padding: 0 8px 0 6px;
    margin: 5px 0;
    transition: all 0.3s ease;
  }

  #custom-power:hover {
    color: #eb6f92;
  }
''
