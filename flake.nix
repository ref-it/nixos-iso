{
  description = "NixOS ISO of the student council of the TU Ilmenau";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }@inputs: {

    iso = (nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [ ./iso.nix ];
    }).config.system.build.isoImage;

    hydraJobs.iso = self.iso;

    overlays.default = (import ./packages);

  } // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages = {
      stura-configure-net = pkgs.callPackage ./packages/stura-configure-net {};
      stura-default-config = pkgs.callPackage ./packages/stura-default-config {};
    };
  });
}
