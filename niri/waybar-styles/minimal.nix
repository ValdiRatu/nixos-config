# Minimal v2 — Refined hierarchy, deliberate use of space and silence
# Clock dominates, stats recede, one warm accent, everything breathes
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
    color: #6e6a86;
  }

  tooltip {
    background: rgba(25, 23, 36, 0.96);
    border: 1px solid rgba(110, 106, 134, 0.2);
    border-radius: 10px;
    color: #e0def4;
    padding: 2px;
  }

  tooltip label {
    color: #e0def4;
    padding: 4px 6px;
  }

  /* ── Layout — two islands + floating clock ──────── */
  .modules-left,
  .modules-right {
    background: rgba(25, 23, 36, 0.72);
    border-radius: 12px;
    padding: 0 6px;
    margin: 6px 0;
  }

  .modules-center {
    background: rgba(25, 23, 36, 0.72);
    border-radius: 12px;
    padding: 0 4px;
    margin: 6px 0;
  }

  .modules-left   { margin-left: 6px; }
  .modules-right  { margin-right: 6px; }

  /* ── Workspaces — underline active ───────────────── */
  #workspaces button {
    padding: 0 8px;
    margin: 7px 2px;
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

  /* ── Window Title — whisper quiet ────────────────── */
  #window {
    color: #6e6a86;
    padding: 0 14px;
    font-size: 11px;
  }

  /* ── Clock — the anchor, largest element ─────────── */
  #clock {
    color: #e0def4;
    font-weight: bold;
    font-size: 14px;
    padding: 0 16px;
    letter-spacing: 0.5px;
  }

  /* ── Media Player ────────────────────────────────── */
  #mpris {
    color: #9ccfd8;
    padding: 0 14px;
    font-size: 11px;
  }

  #mpris.paused {
    color: #44415a;
  }

  /* ── Weather — the single warm accent ────────────── */
  #custom-weather {
    color: #f6c177;
    padding: 0 14px;
    font-size: 12px;
  }

  /* ── Tray ────────────────────────────────────────── */
  #tray {
    padding: 0 8px;
  }

  #tray > .passive {
    -gtk-icon-effect: dim;
  }

  /* ── Right modules — receded, icon-forward ──────── */
  #network,
  #cpu,
  #memory,
  #battery,
  #pulseaudio {
    padding: 0 12px;
    margin: 6px 0;
    color: #6e6a86;
    font-size: 11px;
    transition: color 0.3s ease;
  }

  #network:hover,
  #cpu:hover,
  #memory:hover,
  #battery:hover,
  #pulseaudio:hover {
    color: #e0def4;
  }

  /* ── State colors — only surface when they matter ── */
  #network.disconnected { color: #eb6f92; }

  #cpu.warning          { color: #f6c177; }
  #cpu.critical         { color: #eb6f92; }

  #memory.warning       { color: #f6c177; }
  #memory.critical      { color: #eb6f92; }

  #battery.warning      { color: #f6c177; }
  #battery.critical     {
    color: #eb6f92;
    animation: urgent-pulse 2s ease-in-out infinite;
  }
  #battery.charging     { color: #9ccfd8; }

  #pulseaudio.muted     { color: #44415a; }

  /* ── Power — ghost until needed ──────────────────── */
  #custom-power {
    color: #44415a;
    padding: 0 10px 0 8px;
    margin: 6px 0;
    transition: color 0.3s ease;
  }

  #custom-power:hover {
    color: #eb6f92;
  }

  /* ── Animation ───────────────────────────────────── */
  @keyframes urgent-pulse {
    0%   { opacity: 1; }
    50%  { opacity: 0.4; }
    100% { opacity: 1; }
  }
''
