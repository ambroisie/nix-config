{
  description = "Nixos configuration with flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.porthos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ({ pkgs, ... }: {
            # Let 'nixos-version --json' know about the Git revision
            # of this flake.
            system.configurationRevision =
              if self ? rev
              then self.rev
              else throw "Refusing to build from a dirty Git tree!";
          })
          ./configuration.nix
        ];
    };
  };
}
