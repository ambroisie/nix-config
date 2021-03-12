{
  description = "NixOS configuration with flakes";
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    futils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nur, home-manager, futils }:
    let
      inherit (nixpkgs) lib;
      inherit (futils.lib) eachDefaultSystem;

      defaultModules = [
        ({ ... }: {
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
    eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShell = pkgs.mkShell {
            name = "NixOS-config";
            buildInputs = with pkgs; [
              gitAndTools.pre-commit
              nixpkgs-fmt
            ];
          };
        }) // {
      nixosConfigurations = lib.mapAttrs buildHost {
        porthos = "x86_64-linux";
      };
    };
}
