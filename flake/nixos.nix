{ self, nixpkgs, nur, ... } @ inputs:
let
  inherit (self) lib;

  defaultModules = [
    ({ ... }: {
      # Let 'nixos-version --json' know about the Git revision
      system.configurationRevision = self.rev or "dirty";
    })
    {
      nixpkgs.overlays = (lib.attrValues self.overlays) ++ [
        nur.overlay
      ];
    }
    # Include generic settings
    "${self}/modules"
    # Include bundles of settings
    "${self}/profiles"
  ];

  buildHost = name: system: lib.nixosSystem {
    inherit system;
    modules = defaultModules ++ [
      "${self}/machines/${name}"
    ];
    specialArgs = {
      # Use my extended lib in NixOS configuration
      inherit lib;
      # Inject inputs to use them in global registry
      inherit inputs;
    };
  };
in
lib.mapAttrs buildHost {
  aramis = "x86_64-linux";
  porthos = "x86_64-linux";
}