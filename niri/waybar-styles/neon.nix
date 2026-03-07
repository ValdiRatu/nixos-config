# Neon — Cyberpunk aesthetic with glowing accents and sharp edges
# Deep dark background, neon text-shadows, bottom-border accents
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
    color: #a9b1d6;
  }

  tooltip {
    background: rgba(10, 10, 28, 0.95);
    border: 1px solid rgba(122, 162, 247, 0.4);
    border-radius: 8px;
    color: #c0caf5;
  }

  tooltip label {
    color: #c0caf5;
    padding: 4px 2px;
  }

  /* ── Floating Islands ─────────────────────────── */
  .modules-left,
  .modules-center,
  .modules-right {
    background: rgba(10, 10, 28, 0.9);
    border: 1px solid rgba(122, 162, 247, 0.15);
    border-bottom: 2px solid rgba(122, 162, 247, 0.3);
    border-radius: 8px;
    padding: 0 4px;
    margin: 4px 0;
  }

  .modules-left   { margin-left:  2px; }
  .modules-right  { margin-right: 2px; }

  /* ── Workspaces ────────────────────────────────── */
  #workspaces button {
    padding: 0 8px;
    margin: 5px 2px;
    color: #3b3f5c;
    background: transparent;
    border-radius: 4px;
    font-weight: bold;
    font-size: 12px;
    transition: all 0.2s ease;
  }

  #workspaces button.active,
  #workspaces button.focused {
    color: #7aa2f7;
    background: rgba(122, 162, 247, 0.15);
    text-shadow: 0 0 10px rgba(122, 162, 247, 0.7);
    border-bottom: 2px solid #7aa2f7;
  }

  #workspaces button:hover {
    color: #bb9af7;
    text-shadow: 0 0 8px rgba(187, 154, 247, 0.5);
  }

  /* ── Window Title ──────────────────────────────── */
  #window {
    color: #565f89;
    padding: 0 12px;
    font-style: italic;
  }

  /* ── Clock ─────────────────────────────────────── */
  #clock {
    color: #7aa2f7;
    font-weight: bold;
    padding: 0 14px;
    text-shadow: 0 0 12px rgba(122, 162, 247, 0.5);
  }

  /* ── Media Player ──────────────────────────────── */
  #mpris {
    color: #9ece6a;
    padding: 0 12px;
    text-shadow: 0 0 8px rgba(158, 206, 106, 0.4);
  }

  #mpris.paused {
    color: #3b3f5c;
    text-shadow: none;
  }

  /* ── Weather ───────────────────────────────────── */
  #custom-weather {
    color: #e0af68;
    padding: 0 12px;
    text-shadow: 0 0 8px rgba(224, 175, 104, 0.4);
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

  /* ── Right modules — neon underline accents ────── */
  #network {
    color: #2ac3de;
    padding: 0 12px;
    margin: 5px 2px;
    border-radius: 4px;
    border-bottom: 2px solid transparent;
    transition: all 0.2s ease;
  }

  #network:hover {
    border-bottom-color: #2ac3de;
    text-shadow: 0 0 8px rgba(42, 195, 222, 0.5);
  }

  #network.disconnected {
    color: #f7768e;
  }

  #cpu {
    color: #9ece6a;
    padding: 0 12px;
    margin: 5px 2px;
    border-radius: 4px;
    border-bottom: 2px solid transparent;
    transition: all 0.2s ease;
  }

  #cpu:hover {
    border-bottom-color: #9ece6a;
    text-shadow: 0 0 8px rgba(158, 206, 106, 0.5);
  }

  #cpu.warning {
    color: #e0af68;
    text-shadow: 0 0 6px rgba(224, 175, 104, 0.4);
  }

  #cpu.critical {
    color: #f7768e;
    text-shadow: 0 0 10px rgba(247, 118, 142, 0.6);
    animation: neon-flicker 1s ease-in-out infinite;
  }

  #memory {
    color: #ff9e64;
    padding: 0 12px;
    margin: 5px 2px;
    border-radius: 4px;
    border-bottom: 2px solid transparent;
    transition: all 0.2s ease;
  }

  #memory:hover {
    border-bottom-color: #ff9e64;
    text-shadow: 0 0 8px rgba(255, 158, 100, 0.5);
  }

  #memory.warning {
    color: #e0af68;
    text-shadow: 0 0 6px rgba(224, 175, 104, 0.4);
  }

  #memory.critical {
    color: #f7768e;
    text-shadow: 0 0 10px rgba(247, 118, 142, 0.6);
    animation: neon-flicker 1s ease-in-out infinite;
  }

  #pulseaudio {
    color: #bb9af7;
    padding: 0 12px;
    margin: 5px 2px;
    border-radius: 4px;
    border-bottom: 2px solid transparent;
    transition: all 0.2s ease;
  }

  #pulseaudio:hover {
    border-bottom-color: #bb9af7;
    text-shadow: 0 0 8px rgba(187, 154, 247, 0.5);
  }

  #pulseaudio.muted {
    color: #3b3f5c;
    text-shadow: none;
  }

  /* ── Power Button ──────────────────────────────── */
  #custom-power {
    color: #f7768e;
    padding: 0 10px 0 6px;
    margin: 5px 2px;
    border-radius: 4px;
    transition: all 0.2s ease;
  }

  #custom-power:hover {
    text-shadow: 0 0 12px rgba(247, 118, 142, 0.7);
    border-bottom: 2px solid #f7768e;
  }

  /* ── Neon flicker animation ────────────────────── */
  @keyframes neon-flicker {
    0%   { opacity: 1; }
    25%  { opacity: 0.8; }
    50%  { opacity: 1; }
    75%  { opacity: 0.6; }
    100% { opacity: 1; }
  }
''
