{
  description = "Valdi's NixOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";
  };
  outputs = { self, nixpkgs, niri }: {
    nixosConfigurations.myBox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        niri.nixosModules.niri
      ];
    };
  };
} 
