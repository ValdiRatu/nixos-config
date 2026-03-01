{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  home.username = "valdir";
  home.homeDirectory = "/home/valdir";
  home.stateVersion = osConfig.system.stateVersion;

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    history = {
      size = 1000;
      save = 1000;
      path = "${config.home.homeDirectory}/.histfile";
    };
    shellAliases = {
      gs = "git status";
      sysbuild = "sudo nixos-rebuild switch --flake ~/nixos-config#myBox";
      # only can do this if we have a standalone install of home-manager
      # TODO: look into this!
      # homebuild = "home-manager switch --flake .#valdir";
    };
  };

  programs.git = {
    enable = true;
    settings.user.name = "ValdiRatu";
    settings.user.email = "valdi.ratu@yahoo.com";
  };

  home.packages = with pkgs; [
    # dev
    gh

    # wayland / niri
    wl-clipboard
    waybar
    mako
    fuzzel
    swaylock
    swaybg
    xwayland-satellite
    grim
    slurp

    # apps
    legcord
    zed-editor

    # LSPs
    nil
    nixd
  ];
}
