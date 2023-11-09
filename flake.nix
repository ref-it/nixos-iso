{
  description = "NixOS ISO of netali";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }@inputs: {

    iso = (nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = inputs;
      modules = [ ./iso.nix ];
    }).config.system.build.isoImage;

    hydraJobs.iso = self.iso;

  };
}