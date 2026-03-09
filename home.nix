{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  imports = [
    ./niri
    ./rofi
  ];

  home.username = "valdir";
  home.homeDirectory = "/home/valdir";
  home.stateVersion = osConfig.system.stateVersion;

  programs.niri.settings = {
    input = {
      touchpad = {
        natural-scroll = false;
      };
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    history = {
      size = 1000;
      save = 1000;
      path = "${config.home.homeDirectory}/.histfile";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "z"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      gs = "git status";
      sysbuild = "sudo nixos-rebuild switch --flake ~/nixos-config#myBox";
      zed = "zeditor";
      # only can do this if we have a standalone install of home-manager
      # TODO: look into this!
      # homebuild = "home-manager switch --flake .#valdir";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user.name = "ValdiRatu";
    settings.user.email = "valdi.ratu@yahoo.com";
  };

  home.packages = with pkgs; [
    # dev
    gh
    claude-code

    # wayland / niri
    wl-clipboard
    # waybar is managed by programs.waybar below
    mako
    fuzzel
    swaylock
    xwayland-satellite
    grim
    slurp

    # terminal
    alacritty
    ghostty

    # fonts (needed for waybar icons)
    nerd-fonts.jetbrains-mono

    # media / audio
    playerctl
    pavucontrol

    # apps
    legcord
    zed-editor
    networkmanagerapplet

    # LSPs
    nil
    nixd
    
    # background
    awww
    waypaper
  ];
}
