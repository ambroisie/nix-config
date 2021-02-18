{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur }:
    let
      buildHost = name: system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision =
              if self ? rev
              then self.rev
              else throw "Refusing to build from a dirty Git tree!";
          })
          { nixpkgs.overlays = [ nur.overlay ]; }
          (./. + "/${name}.nix")
        ];
      };
    in
    {
      nixosConfigurations = nixpkgs.lib.mapAttrs buildHost {
        porthos = "x86_64-linux";
      };
    };
}
