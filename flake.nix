{
  description = "NixOS configuration with flakes";
  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    futils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nur, home-manager, futils } @ inputs:
    let
      inherit (futils.lib) eachDefaultSystem;

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib { inherit inputs; pkgs = nixpkgs; lib = self; };
      });

      defaultModules = [
        ({ ... }: {
          # Let 'nixos-version --json' know about the Git revision
          system.configurationRevision =
            if self ? rev
            then self.rev
            else throw "Refusing to build from a dirty Git tree!";
        })
        { nixpkgs.overlays = [ nur.overlay self.overlay ]; }
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
              git-crypt
              gitAndTools.pre-commit
              gnupg
              nixpkgs-fmt
            ];
          };
        }) // {
      overlay = self.overlays.lib;

      overlays = {
        lib = final: prev: { inherit lib; };
      };

      nixosConfigurations = lib.mapAttrs buildHost {
        porthos = "x86_64-linux";
      };
    };
}
