# Frost — Glassmorphism floating islands with Catppuccin Mocha palette
# Frosted translucent pills, soft colored backgrounds, smooth transitions
''
  /* ── Base ──────────────────────────────────────── */
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
    background: rgba(30, 30, 46, 0.95);
    border: 1px solid rgba(137, 180, 250, 0.3);
    border-radius: 12px;
    color: #cdd6f4;
  }

  tooltip label {
    color: #cdd6f4;
    padding: 4px 2px;
  }

  /* ── Floating Islands ─────────────────────────── */
  .modules-left,
  .modules-center,
  .modules-right {
    background: rgba(30, 30, 46, 0.82);
    border: 1px solid rgba(108, 112, 134, 0.35);
    border-radius: 14px;
    padding: 0 4px;
    margin: 4px 0;
  }

  .modules-left   { margin-left:  2px; }
  .modules-right  { margin-right: 2px; }

  /* ── Workspaces ────────────────────────────────── */
  #workspaces button {
    padding: 0 8px;
    margin: 5px 2px;
    color: #585b70;
    background: transparent;
    border-radius: 8px;
    font-weight: bold;
    font-size: 12px;
    transition: all 0.3s ease;
  }

  #workspaces button.active,
  #workspaces button.focused {
    color: #1e1e2e;
    background: #89b4fa;
  }

  #workspaces button:hover {
    color: #cdd6f4;
    background: rgba(137, 180, 250, 0.2);
  }

  /* ── Window Title ──────────────────────────────── */
  #window {
    color: #7f849c;
    padding: 0 12px;
    font-style: italic;
  }

  /* ── Clock ─────────────────────────────────────── */
  #clock {
    color: #89b4fa;
    font-weight: bold;
    padding: 0 14px;
  }

  /* ── Media Player ──────────────────────────────── */
  #mpris {
    color: #a6e3a1;
    padding: 0 12px;
  }

  #mpris.paused {
    color: #585b70;
  }

  /* ── Weather ───────────────────────────────────── */
  #custom-weather {
    color: #f9e2af;
    padding: 0 12px;
  }

  /* ── Tray ──────────────────────────────────────── */
  #tray {
    padding: 0 8px;
  }

  #tray > .passive {
    -gtk-icon-effect: dim;
  }

  #tray > .needs-attention {
    -gtk-icon-effect: highlight;
  }

  /* ── Right modules — colored background pills ─── */
  #network {
    color: #89dceb;
    background: rgba(137, 220, 235, 0.1);
    border-radius: 10px;
    padding: 0 12px;
    margin: 5px 2px;
    transition: all 0.3s ease;
  }

  #network.disconnected {
    color: #f38ba8;
    background: rgba(243, 139, 168, 0.1);
  }

  #network:hover {
    background: rgba(137, 220, 235, 0.18);
  }

  #cpu {
    color: #a6e3a1;
    background: rgba(166, 227, 161, 0.1);
    border-radius: 10px;
    padding: 0 12px;
    margin: 5px 2px;
    transition: all 0.3s ease;
  }

  #cpu.warning {
    color: #f9e2af;
    background: rgba(249, 226, 175, 0.12);
  }

  #cpu.critical {
    color: #f38ba8;
    background: rgba(243, 139, 168, 0.15);
    animation: pulse 1.5s ease-in-out infinite;
  }

  #cpu:hover {
    background: rgba(166, 227, 161, 0.18);
  }

  #memory {
    color: #fab387;
    background: rgba(250, 179, 135, 0.1);
    border-radius: 10px;
    padding: 0 12px;
    margin: 5px 2px;
    transition: all 0.3s ease;
  }

  #memory.warning {
    color: #f9e2af;
    background: rgba(249, 226, 175, 0.12);
  }

  #memory.critical {
    color: #f38ba8;
    background: rgba(243, 139, 168, 0.15);
    animation: pulse 1.5s ease-in-out infinite;
  }

  #memory:hover {
    background: rgba(250, 179, 135, 0.18);
  }

  #pulseaudio {
    color: #cba6f7;
    background: rgba(203, 166, 247, 0.1);
    border-radius: 10px;
    padding: 0 12px;
    margin: 5px 2px;
    transition: all 0.3s ease;
  }

  #pulseaudio.muted {
    color: #585b70;
    background: rgba(88, 91, 112, 0.1);
  }

  #pulseaudio:hover {
    background: rgba(203, 166, 247, 0.18);
  }

  /* ── Power Button ──────────────────────────────── */
  #custom-power {
    color: #f38ba8;
    padding: 0 10px 0 6px;
    margin: 5px 2px;
    border-radius: 10px;
    transition: all 0.3s ease;
  }

  #custom-power:hover {
    background: rgba(243, 139, 168, 0.15);
  }

  /* ── Pulse animation ───────────────────────────── */
  @keyframes pulse {
    0%   { opacity: 1; }
    50%  { opacity: 0.5; }
    100% { opacity: 1; }
  }
''
