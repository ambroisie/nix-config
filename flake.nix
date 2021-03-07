{
  description = "NixOS configuration with flakes";
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur, home-manager }:
    let
      inherit (nixpkgs) lib;

      defaultModules = [
        ({ pkgs, ... }: {
          # Let 'nixos-version --json' know about the Git revision
          system.configurationRevision =
            if self ? rev
            then self.rev
            else throw "Refusing to build from a dirty Git tree!";
        })
        { nixpkgs.overlays = [ nur.overlay ]; }
        home-manager.nixosModules.home-manager
        {
          home-manager.users.ambroisie = import ./home;
          # Nix Flakes compatibility
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      buildHost = name: system: lib.nixosSystem {
        inherit system;
        modules = defaultModules ++ [
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
