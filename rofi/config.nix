{ pkgs, config, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "alacritty";
    font = "JetBrainsMono Nerd Font 12";

    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      kb-move-sel-next = "j,Down,Tab";
      kb-move-sel-prev = "k,Up,ISO_Left_Tab";
      kb-row-first = "g";
      kb-row-last = "G";
      kb-cancel = "q,Escape";
    };

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*" = {
          bg = mkLiteral "#1a1a2e";
          accent = mkLiteral "#7fc8ff";
          fg = mkLiteral "#cdd6f4";
          bg-alt = mkLiteral "#16213e";
          selected-bg = mkLiteral "#0f3460";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg";
        };
        "window" = {
          background-color = mkLiteral "@bg";
          border = mkLiteral "2px solid";
          border-color = mkLiteral "@accent";
          border-radius = mkLiteral "8px";
          width = mkLiteral "640px";
        };
        "mainbox" = {
          background-color = mkLiteral "@bg";
        };
        "inputbar" = {
          background-color = mkLiteral "@bg-alt";
          border-radius = mkLiteral "4px";
          padding = mkLiteral "8px 12px";
          margin = mkLiteral "8px";
          children = map mkLiteral [ "prompt" "entry" ];
        };
        "prompt" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@accent";
          padding = mkLiteral "0 6px 0 0";
        };
        "entry" = {
          background-color = mkLiteral "transparent";
        };
        "listview" = {
          background-color = mkLiteral "@bg";
          padding = mkLiteral "4px 8px 8px";
          lines = 10;
          scrollbar = false;
        };
        "element" = {
          background-color = mkLiteral "transparent";
          border-radius = mkLiteral "4px";
          padding = mkLiteral "6px 8px";
        };
        "element selected" = {
          background-color = mkLiteral "@selected-bg";
          text-color = mkLiteral "@accent";
        };
        "element-text" = {
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
        };
      };
  };
}
