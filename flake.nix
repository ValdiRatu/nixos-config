{
  description = "Valdi's NixOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";
    home-manager = {
      url = "github:nix-community/home-manager" ;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code.url = "github:sadjow/claude-code-nix";
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };
  outputs = { self, nixpkgs, niri, home-manager, claude-code, awww }: {
    overlays.default = final: prev: {
      spacetimedb-self = final.callPackage ./packages/spacetimedb.nix {};
    };
    nixosConfigurations.myBox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        niri.nixosModules.niri
        { nixpkgs.overlays = [ 
          claude-code.overlays.default 
          awww.overlays.default
          (final: prev: {
            spacetimedb-self = final.callPackage ./packages/spacetimedb.nix {};
          })
        ]; }
        home-manager.nixosModules.home-manager {
          home-manager.users.valdir = import ./home.nix;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
} 
