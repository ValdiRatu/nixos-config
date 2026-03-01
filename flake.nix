{
  description = "Valdi's NixOS config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
    ];
  };
} 
