{ pkgs, ... }:

let
  niri-window-picker = pkgs.writeShellApplication {
    name = "niri-window-picker";
    runtimeInputs = with pkgs; [ jq rofi ];
    text = ''
      current_ws=$(niri msg --json workspaces \
        | jq -r '.[] | select(.is_focused == true) | .id')

      [ -z "$current_ws" ] && exit 0

      windows_json=$(niri msg --json windows \
        | jq --argjson ws "$current_ws" '[.[] | select(.workspace_id == $ws)]')

      count=$(echo "$windows_json" | jq 'length')
      [ "$count" -eq 0 ] && exit 0

      display=$(echo "$windows_json" \
        | jq -r '.[] | "\(.app_id) \u2014 \(.title)"')

      idx=$(echo "$display" | rofi -dmenu -p "Go to:" -format i -i) || true

      [ -z "$idx" ] && exit 0

      id=$(echo "$windows_json" | jq -r ".[$idx].id")
      niri msg action focus-window --id "$id"
    '';
  };
in
{
  home.packages = with pkgs; [
    jq
    niri-window-picker
  ];
}
